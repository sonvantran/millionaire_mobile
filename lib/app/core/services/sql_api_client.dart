import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/item_model.dart';
import '../../data/model/user.dart';
import '../../network/exceptions/bad_request_exception.dart';

/// Gọi MillionaireApi (chạy trên máy bạn) để lấy câu hỏi và lưu/đọc xếp hạng trong SQL Server.
class SqlApiClient {
  SqlApiClient._();
  static final SqlApiClient instance = SqlApiClient._();

  static const String baseUrl = 'http://localhost:5080';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Đổi mọi lỗi mạng/API thành BadRequestException để các chỗ xử lý lỗi sẵn có của game dùng được.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMsg = data is Map ? data['message']?.toString() : null;
      throw BadRequestException(
        httpCode: e.response?.statusCode ?? 0,
        status: 'sql_api_error',
        message: serverMsg ??
            'Không kết nối được máy chủ SQL (đã chạy MillionaireApi chưa?)',
      );
    }
  }

  // ------------------------------------------------------------ Câu hỏi

  /// Lấy ngẫu nhiên 1 câu chưa hỏi ở level này (hết câu thì API tự reset level đó).
  Future<Map<String, dynamic>> getRandomQuestion(int level) => _guard(() async {
        final res = await _dio
            .get('/api/questions/random', queryParameters: {'level': level});
        return Map<String, dynamic>.from(res.data as Map);
      });

  /// Đánh dấu câu hỏi đã hỏi (gọi khi câu hỏi thật sự hiện ra).
  Future<void> markAsked(int id) => _guard(() async {
        await _dio.post('/api/questions/$id/asked');
      });

  // ------------------------------------------------------------ Xếp hạng

  User _userFromMap(Map<String, dynamic> m) => User(
        name: m['name'] as String,
        point: (m['score'] as num).toInt(),
        deviceId: m['deviceId'] as String?,
        playDate: m['playDate'] != null
            ? Timestamp.fromDate(DateTime.parse(m['playDate'] as String))
            : null,
        image: m['image'] as String?,
        boughtItem:
            (m['boughtItem'] as List?)?.map((e) => e.toString()).toList(),
      );

  Future<List<User>> getRanking({required bool all}) => _guard(() async {
        final res = await _dio.get('/api/ranking',
            queryParameters: {'type': all ? 'all' : 'day', 'limit': 60});
        return (res.data as List)
            .map((e) => _userFromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      });

  /// Lấy 1 người chơi theo tên. Chưa có trong SQL thì trả về null.
  Future<User?> getPlayer(String name) async {
    try {
      return await _guard(() async {
        final res = await _dio
            .get('/api/players/one', queryParameters: {'name': name});
        return _userFromMap(Map<String, dynamic>.from(res.data as Map));
      });
    } on BadRequestException catch (e) {
      if (e.httpCode == 404) return null;
      rethrow;
    }
  }

  /// Lưu/cập nhật người chơi (theo tên). Thay cho FirestoreManager.updateUser.
  Future<User> updatePlayer(User user) async {
    if (user.name.isEmpty) {
      throw BadRequestException(
          httpCode: 400, status: 'sql_api_error', message: 'Thiếu tên người chơi');
    }
    final pre = await SharedPreferences.getInstance();
    final bought = pre.getStringList('boughtItem') ?? <String>[];
    await _guard(() async {
      await _dio.put('/api/players', data: {
        'name': user.name,
        'score': user.point,
        'image': user.image,
        'deviceId': user.deviceId,
        'boughtItem': bought,
      });
    });
    // giữ nguyên hành vi cũ: RankingCubit dùng 2 giá trị này để biết có cần gửi lại không
    await pre.setInt('lastPoint', user.point);
    await pre.setString('lastName', user.name);
    return user;
  }

  Future<void> deletePlayer(String name) => _guard(() async {
        await _dio.delete('/api/players', queryParameters: {'name': name});
      });

  // ------------------------------------------------------------ Cửa hàng

  /// Tên các nhóm của cửa hàng (cùng thứ tự với danh sách trả về từ getStore).
  List<String> storeLabels = [];

  Future<List<List<ItemModel>>> getStore() => _guard(() async {
        final res = await _dio.get('/api/store');
        final labels = <String>[];
        final store = <List<ItemModel>>[];
        for (final c in (res.data as List)) {
          final cat = Map<String, dynamic>.from(c as Map);
          labels.add(cat['category'] as String);
          store.add((cat['items'] as List).map((i) {
            final m = Map<String, dynamic>.from(i as Map);
            return ItemModel(
              name: m['name'] as String,
              price: (m['price'] as num).toInt().toString(),
              image: m['image'] as String,
            );
          }).toList());
        }
        storeLabels = labels;
        return store;
      });
}
import 'package:millionaire_mobile/app/network/exceptions/bad_request_exception.dart';

import '../../../core/services/firestore_manager.dart';
import '../../../data/model/user.dart';

class LoginApi {
  final fs = FirestoreManager();
  Future<User> getUser({
    required String deviceId,
  }) async {
    final result = await fs.getUser(deviceId);
    if (result == null) {
      throw BadRequestException(
          httpCode: 404, status: "status", message: "User không tồn tại");
    } else {
      return result;
    }
  }

  Future<String> getBad() async {
    final result = await fs.getBad();
    if (result == null) {
      throw BadRequestException(
          httpCode: 404, status: "status", message: "không tồn tại");
    } else {
      return result;
    }
  }

  Future<User> updateUser({
    required User user,
  }) async {
    final user1 = await fs.updateUser(user);
    if (user1 != null) return user1;
    throw BadRequestException(
        httpCode: 404, status: "status", message: "lỗi update");
  }

  Future<String> deleteUser({
    required String deviceId,
  }) async {
    final user1 = await fs.deleteUser(deviceId);
    if (user1 != null) return user1;
    throw BadRequestException(
        httpCode: 404, status: "status", message: "lỗi delete");
  }
}

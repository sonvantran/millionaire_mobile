import '../../../core/services/firestore_manager.dart';
import '../../../data/model/user.dart';
import '../../../network/exceptions/bad_request_exception.dart';

class RankingApi {
  final FirestoreManager fs = FirestoreManager();
  Future<List<User>> getRank() async {
    try {
      final result = fs.getRanking();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getAllRank() async {
    try {
      final result = fs.getAllRanking();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> optimize() async {
    try {
      fs.optimize();
    } catch (e) {
      rethrow;
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
}

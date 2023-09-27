import '../../../core/services/firestore_manager.dart';
import '../../../core/services/question_handle.dart';
import '../../../data/model/question.dart';
import '../../../data/model/user.dart';
import '../../../network/exceptions/bad_request_exception.dart';

class PlayGameApi {
  final fs = FirestoreManager();
  Future<List<Question>> getQuestions() async {
    try {
      final a = QuestionHandle();
      a.getQuestions();
      return a.getQuestions();
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

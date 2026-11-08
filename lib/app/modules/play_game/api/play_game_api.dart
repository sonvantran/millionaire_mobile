import '../../../core/services/question_handle.dart';
import '../../../core/services/sql_api_client.dart';
import '../../../data/model/question.dart';
import '../../../data/model/user.dart';

class PlayGameApi {
  Future<List<Question>> getQuestions() => QuestionHandle().getQuestions();

  Future<User> updateUser({required User user}) =>
      SqlApiClient.instance.updatePlayer(user);
}
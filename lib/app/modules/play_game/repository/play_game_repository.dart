import '../../../data/model/question.dart';
import '../../../data/model/user.dart';
import '../api/play_game_api.dart';

class PlayGameRepository {
  final PlayGameApi _api;
  PlayGameRepository(this._api);

  Future<List<Question>> getQuestions() async {
    try {
      return _api.getQuestions();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser({required User user}) {
    try {
      return _api.updateUser(user: user);
    } catch (e) {
      rethrow;
    }
  }
}

import '../../../data/model/user.dart';
import '../api/ranking_api.dart';

class RankingRepository {
  final RankingApi _api;
  RankingRepository(this._api);

  Future<List<User>> getRank() async {
    try {
      return _api.getRank();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getAllRank() async {
    try {
      return _api.getAllRank();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> optimize() async {
    try {
      return _api.optimize();
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

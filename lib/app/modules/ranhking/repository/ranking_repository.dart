import '../../../data/model/user.dart';
import '../api/ranking_api.dart';

class RankingRepository {
  final RankingApi _api;
  RankingRepository(this._api);

  Future<List<User>> getRank(String type) async {
    try {
      return _api.getRank(type);
    } catch (e) {
      rethrow;
    }
  }
}

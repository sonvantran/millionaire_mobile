import '../../../core/services/sql_api_client.dart';
import '../../../data/model/user.dart';

class RankingApi {
  Future<List<User>> getRank() => SqlApiClient.instance.getRanking(all: false);
  Future<List<User>> getAllRank() => SqlApiClient.instance.getRanking(all: true);
  Future<void> optimize() async {} // trước đây dọn user cũ trên Firestore
  Future<User> updateUser({required User user}) =>
      SqlApiClient.instance.updatePlayer(user);
}
import '../../../core/base/base_remote_source.dart';
import '../../../core/services/firestore_manager.dart';
import '../../../data/model/user.dart';

class RankingApi extends BaseRemoteSource {
  final FirestoreManager fs = FirestoreManager();
  Future<List<User>> getRank(String type) async {
    try {
      final result = fs.getRanking(type);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

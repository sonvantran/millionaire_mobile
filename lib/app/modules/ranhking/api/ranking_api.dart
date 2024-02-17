import '../../../core/services/firestore_manager.dart';
import '../../../data/model/user.dart';

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
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/model/user.dart';
import '../api/store_api.dart';

class StoreRepository {
  final StoreApi _api;

  StoreRepository(StoreApi api) : _api = api;

  Future<List<DocumentChange<Map<String, dynamic>>>> getStore() async {
    return _api.getStore();
  }

  Future<User> updateUser({required User user}) {
    try {
      return _api.updateUser(user: user);
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../api/store_api.dart';

class StoreRepository {
  final StoreApi _api;

  StoreRepository(StoreApi api) : _api = api;

  Future<List<DocumentChange<Map<String, dynamic>>>> getStore() async {
    return _api.getStore();
  }
}

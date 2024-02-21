import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firestore_manager.dart';

class StoreApi {
  final FirestoreManager fs = FirestoreManager();

  Future<List<DocumentChange<Map<String, dynamic>>>> getStore() async {
    try {
      return fs.getStore();
    } catch (e) {
      rethrow;
    }
  }
}

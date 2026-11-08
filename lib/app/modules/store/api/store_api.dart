import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firestore_manager.dart';
import '../../../data/model/user.dart';
import '../../../network/exceptions/bad_request_exception.dart';
import '../../../core/services/sql_api_client.dart';
import '../../../data/model/item_model.dart';

class StoreApi {
  final FirestoreManager fs = FirestoreManager();

  Future<List<List<ItemModel>>> getStoreItems() =>
      SqlApiClient.instance.getStore();
  
  Future<List<DocumentChange<Map<String, dynamic>>>> getStore() async {
    try {
      return fs.getStore();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser({
    required User user,
  }) async {
    final user1 = await fs.updateUser(user);
    if (user1 != null) return user1;
    throw BadRequestException(
        httpCode: 404, status: "status", message: "lỗi update");
  }
}

import 'package:hive/hive.dart';

import '../../data/model/item_model.dart';

class StoreBox {
  static const String storeBox = 'store_box';

  static Future<void> openBox() async {
    await Hive.openBox<Store>(storeBox);
  }

  static Box<Store> getStoreBox() {
    final box = Hive.box<Store>(storeBox);
    return box;
  }

  static void setStore(Store history) {
    final historyBox = getStoreBox();
    historyBox.add(history);
  }

  static List<Store> getStore() {
    final storeBox = getStoreBox();
    final historyList = storeBox.values.toList();
    return historyList;
  }

  static Future<int> deleteAll() {
    final storeBox = getStoreBox();
    final result = storeBox.clear();
    return result;
  }
}

import 'package:hive_flutter/hive_flutter.dart';

part 'item_model.g.dart';

@HiveType(typeId: 2)
class ItemModel {
  @HiveField(1)
  bool isBuy;
  @HiveField(2)
  String name;
  @HiveField(3)
  String price;
  @HiveField(4)
  String image;
  ItemModel({
    this.isBuy = false,
    required this.name,
    required this.price,
    required this.image,
  });

  static List<ItemModel> fromMap(Map<String, dynamic> map) {
    List<ItemModel> tempt = [];
    map.forEach((key, value) {
      List<String> parts = key.split('-');
      tempt.add(ItemModel(name: parts[1], price: parts[0], image: value));
    });
    return tempt;
  }
}

@HiveType(typeId: 3)
class Store {
  @HiveField(1)
  List<List<ItemModel>> store;
  Store({
    required this.store,
  });
}

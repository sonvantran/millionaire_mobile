import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  int point;
  String? deviceId;
  Timestamp? playDate;
  String? image;
  List<String>? boughtItem;
  User({
    required this.name,
    required this.point,
    this.deviceId,
    this.playDate,
    this.image,
    this.boughtItem,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      point: map['score'] != null ? map['score'] as int : 0,
      deviceId: map['device_id'] != null ? map['device_id'] as String : null,
      playDate: map['play_date'] != null ? map['play_date'] as Timestamp : null,
      image: map['image'] != null ? map['image'] as String : null,
      boughtItem: map['boughtItem'] != null
          ? (map['boughtItem'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'score': point,
      'device_id': deviceId,
      'play_date': playDate,
      'image': image,
      'boughtItem': boughtItem,
    };
  }

  User copyWith({
    String? name,
    int? point,
    String? deviceId,
    Timestamp? playDate,
    String? image,
    List<String>? boughtItem,
  }) {
    return User(
      name: name ?? this.name,
      point: point ?? this.point,
      deviceId: deviceId ?? this.deviceId,
      playDate: playDate ?? this.playDate,
      image: image ?? this.image,
      boughtItem: boughtItem ?? this.boughtItem,
    );
  }
}

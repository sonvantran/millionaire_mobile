import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  int point;
  String? deviceId;
  Timestamp? playDate;
  User({
    required this.name,
    required this.point,
    this.deviceId,
    this.playDate,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      point: map['score'] != null ? map['score'] as int : 0,
      deviceId: map['device_id'] != null ? map['device_id'] as String : null,
      playDate: map['play_date'] != null ? map['play_date'] as Timestamp : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'score': point,
      'device_id': deviceId,
      'play_date': playDate,
    };
  }
}

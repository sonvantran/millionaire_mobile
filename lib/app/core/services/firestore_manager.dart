import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/user.dart';

class FirestoreManager {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> updateUser(User user) async {
    await firestore.collection("users").doc(user.deviceId).set(user.toMap());
    return user;
  }

  Future<String?> deleteUser(String deviceId) async {
    await firestore.collection("users").doc(deviceId).delete();
    return "Xoá thành công";
  }

  Future<User?> getUser(String id) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(id).get();

    if (documentSnapshot.exists) {
      return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<String?> getBad() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('bads').doc("te").get();

    if (documentSnapshot.exists) {
      return (documentSnapshot.data() as Map<String, dynamic>)["tu"];
    } else {
      return null;
    }
  }

  Future<List<User>> getRanking(String type) async {
    DateTime currentDate = DateTime.now();

    DateTime startDate = type == "day"
        ? DateTime(currentDate.year, currentDate.month, currentDate.day)
        : type == "month"
            ? DateTime(currentDate.year, currentDate.month)
            : DateTime(currentDate.year);
    DateTime endDate = type == "day"
        ? DateTime(currentDate.year, currentDate.month, currentDate.day + 1)
        : type == "month"
            ? DateTime(currentDate.year, currentDate.month + 1)
            : DateTime(currentDate.year + 1);

    QuerySnapshot qs = await firestore
        .collection("users")
        .where("play_date",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where("play_date", isLessThan: Timestamp.fromDate(endDate))
        .orderBy("play_date", descending: true)
        .limit(100)
        .get();

    List<User> users = qs.docs
        .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    users.sort((user1, user2) => user2.point.compareTo(user1.point));

    return users.take(30).toList();
  }
}

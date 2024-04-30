import 'package:cloud_firestore/cloud_firestore.dart';

extension TimeStampX on Timestamp {
  String toLastest() {
    final now = Timestamp.now();
    final difference = now.toDate().difference(toDate());

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} giây trước';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${difference.inDays ~/ 30} tháng trước';
    }
  }
}

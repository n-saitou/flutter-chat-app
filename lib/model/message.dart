import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final bool isMe;
  final Timestamp sendTime;

  Message({required this.message, required this.isMe, required this.sendTime});
}

// import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final int senderUserId;
  final int roomId;
  final String message;
  final String timestamp;
  String? avatar;

  Message({
    required this.senderUserId,
    required this.roomId,
    required this.message,
    required this.timestamp,
  });

  Message.fromjson(Map<String, dynamic> data)
      : senderUserId = data['sendUserId'],
        roomId = data['roomId'],
        message = data['content'],
        timestamp = data['sendTime'];

  void setavatar(String avatar) {
    this.avatar = avatar;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderEmail;
  final String message;
  final String receiverId;
  final String senderId;
  final Timestamp timestamp;

  Message({
    required this.senderEmail,
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.timestamp,
  });

  //convert message to a map
  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "message": message,
      "receiverId": receiverId,
      "timestamp": timestamp,
    };
  }
}

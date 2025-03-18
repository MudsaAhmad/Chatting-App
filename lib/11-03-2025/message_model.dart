
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  final String senderId;
  final String senderEmail;
  final String recieverId;
  final String message;
  final Timestamp timestamp;

  MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.recieverId,
    required this.message,
    required this.timestamp
});

  // Convert to map that's how the information stored in firebase.
Map<String, dynamic> toMap () {
  return {
    'senderId': senderId,
    'senderEmail': senderEmail,
    'recieverId': recieverId,
    'message': message,
    'timeStamp' :timestamp,
  };
}
}
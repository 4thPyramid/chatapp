import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String senderId;
  final String receiverId; // أضف الحقل هنا
  final Timestamp timestamp;

  Message({
    required this.text,
    required this.senderId,
    required this.receiverId, // أضف الحقل هنا
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Message(
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '', // أضف الحقل هنا
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId, // أضف الحقل هنا
      'timestamp': timestamp,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime timestamp;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

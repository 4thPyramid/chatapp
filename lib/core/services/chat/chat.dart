import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final String userEmail;

  Chat({
    required this.chatId,
    required this.userEmail,
  });

  // دالة لتحويل بيانات من Firestore إلى كائن Chat
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Chat(
      chatId: doc.id,  // نستخدم ID الوثيقة كـ chatId
      userEmail: data['userEmail'] ?? '', // أو أي خاصية تريد استخدامها
    );
  }

  // تحويل كائن Chat إلى Map إذا كنت تريد إرسال البيانات إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
    };
  }
}

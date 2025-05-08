import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FCMService {
  static const String _serverKey = 'YOUR_FCM_SERVER_KEY';

  static Future<void> sendNotificationToUser({
    required String receiverId,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final fcmToken = userDoc.data()?['fcmToken'];
    if (fcmToken == null) return;

    final payload = {
      'to': fcmToken,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': data,
    };

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
      body: jsonEncode(payload),
    );
  }
}

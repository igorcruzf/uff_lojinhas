

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotification {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final String serverToken = 'AAAAZowRQqw:APA91bEvn4Yj0WmJ5mGL9r6jt9vsM7042TdUHzOS5hKZHTjhLd03uLzb126gdssvX2YcFHhUr1izF2TLV5z5M_TvLUSQt9yMEk7ao4w1_tbo1bcTlG4PA0U9t8u2GDHRCFka4d6mKu0P';


  Future<void> sendMessage(String body, String title) async {
    var result = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '/topics/notifications',
        },
      ),
    );
  }
}
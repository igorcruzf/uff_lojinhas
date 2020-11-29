

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotification {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final String serverToken = 'AAAAshE3w6U:APA91bHMhNPaSsLuMbk3Z52EHTheEdgowAs-LssjolR-ciOQyjNn6gQxrjLxhvXUnul22oERRkoyqX2uO1tDd609vek8KVfvFaN9hhvKkStD7U7pujLinb1x9xi7FXfiJUd__zoLRk4W';


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
    print(result);
  }
}
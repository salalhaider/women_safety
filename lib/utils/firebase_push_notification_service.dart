// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/local_notif.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

void initNotifs(BuildContext context) async {
  await _fcm.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // _fcm

  _fcm.getInitialMessage().then((RemoteMessage? message) async {
    print('##############################\n');
    print('----------initial message--------');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('##############################\n');
  });

  // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  //   print('------------message---##########-> $message');
  //    if (message != null && message.data.containsKey('jobId')) {
  //     print('-------Backcground Message data---->${message.data}');
  //     dashboardCubit.goToOrderDetailsNotif(
  //         currentSupplier, message.data['jobId'], message.data['orderNumber']);
  //   }
  //   return;
  // });
  // FirebaseMessaging.onBackgroundMessage((message) async {});

  FirebaseMessaging.onMessage.listen((message) async {
    RemoteNotification notification = message.notification!;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await showNotification(
        notification.title ?? '',
        notification.body ?? '',
        context,
        message.data['jobId'],
        message.data['laneId'],
        message.data['notifType'],
        message.data['orderNumber'],
      );
    }
  });
}

sendNotification(String token, String title, String body) async {
  var serverKey =
      'AAAAq1ekGAo:APA91bFi_zhQgH7TS1C8_HGws29W2XYsJ4fnp-OE-2wrklZrOmqnMYiolsW4UxjIC7WSP9bzwhQ7kGJ8nql6w8YbhJX7z6KYRRSz3fhU43ODinf8zahs7K_9cFrhMZyP_9i4Tx2yFn7Y';
// QuerySnapshot ref =
//     await FirebaseFirestore.instance.collection('users').get();

  try {
    // ref.docs.forEach((snapshot) async {
    http.Response response = await http
        .post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token //snapshot.data() ['tokenID'],
        },
      ),
    )
        .then((value) {
      print('--------- fcm then -----------');
      print('\n\n----------response -------> $value\n\n');
      return value;
    });

    // });
  } catch (e) {
    print("error push notification");
  }
}

// Get the token, save it to the database for current user
Future<String?> saveDeviceToken() async {
  // Get the current user
  String? uid = _auth.currentUser?.uid;

  if (uid != null) {
    // Get the token for this device
    String? fcmToken = await _fcm.getToken();
    notifToken = fcmToken;

    // Save it to Firestore
    if (fcmToken != null) {
      // DocumentReference tokens =
      DocumentReference tokens = await _db
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => value.reference);

      tokens.update({
        'notifToken': fcmToken,
      });
      return fcmToken;
    } else {
      return null;
    }
  } else
    return null;
}

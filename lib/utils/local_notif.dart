import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'globals.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel? channel;
BuildContext? rootContext;
void initializeLocalNotifications(BuildContext context) async {
  rootContext = context;

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for Bridgelinx core notifications.', // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('psl_truck'),
  );
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final MacOSInitializationSettings initializationSettingsMacOS =
  //     MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  // macOS: initializationSettingsMacOS
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);
}

Future onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  // // //print'local notif received');
}

Future selectNotification(String? payload) async {
  if (payload != null) {
  }
}

Future<void> showNotification(String title, String body, BuildContext context,
    String jobId, String laneId, String notifType, String orderNumber) async {
  // print('hello in show notif');
  // print(notifType);
  // print(notifType == 'fullScreen');
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker',
    playSound: true,
    fullScreenIntent: notifType == 'fullScreen' ? true : false,
    autoCancel: true,
    icon: '@mipmap/ic_launcher',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    subtitle: title,
  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  String payloadd = json.encode({
    'jobId': jobId,
    'context': context.toString(),
    'title': title,
    'laneId': laneId,
    'orderNumber': orderNumber,
  });
  // // //printpayloadd);
  await flutterLocalNotificationsPlugin
      .show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payloadd,
      )
      .then((value) {});

  // FlutterRingtonePlayer.play(
  //   android: AndroidSounds.notification,
  //   ios: IosSounds.glass,
  //   looping: false, // Android only - API >= 28
  //   volume: 1, // Android only - API >= 28
  //   asAlarm: true, // Android only - all APIs
  // );
}
// Local Notifications End

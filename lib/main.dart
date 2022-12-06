import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/home.dart';
import 'package:women_safety_app/screens/auth/login.dart';
import 'package:women_safety_app/screens/auth/sign_in_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('********-----Background Message-------*******');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyABEa09m4zYansC1ZNQG3PH8_xaDT6wYgI",
      authDomain: "women-safety-app-7613c.firebaseapp.com",
      projectId: "women-safety-app-7613c",
      storageBucket: "women-safety-app-7613c.appspot.com",
      messagingSenderId: "735909779466",
      appId: "1:735909779466:web:021660edbaa0f0c6b867f3",
      measurementId: "G-8DPRM4THK8",
    ));
  } else {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Women Safety App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      // routes: {},
      home: const HomePage(),
    );
  }
}

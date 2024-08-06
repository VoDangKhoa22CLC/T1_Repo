import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/home.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/screen/signup.dart';
import 'package:lookout_dev/screen/welcome.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
//
// web       1:38111035694:web:42563bc6eb15041d3f3abf
// android   1:38111035694:android:2cc5fd0f271bfae73f3abf
// ios       1:38111035694:ios:f6cd211ab819d97c3f3abf
// macos     1:38111035694:ios:f6cd211ab819d97c3f3abf
// windows   1:38111035694:web:4a5ca1db22aa34dc3f3abf

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      )),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        Home.id: (context) => const Home(),
      },
    );
  }
}

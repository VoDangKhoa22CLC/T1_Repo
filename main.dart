import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/home.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/screen/signup.dart';
import 'package:lookout_dev/screen/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'notification_configure/notification.dart';
import 'package:lookout_dev/screen/create_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initNotification();

  // Check the initial auth state
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(initialRoute: user != null ? Home.id : WelcomeScreen.id));
  // runApp(const MainApp());
}
//
// web       1:38111035694:web:42563bc6eb15041d3f3abf
// android   1:38111035694:android:2cc5fd0f271bfae73f3abf
// ios       1:38111035694:ios:f6cd211ab819d97c3f3abf
// macos     1:38111035694:ios:f6cd211ab819d97c3f3abf
// windows   1:38111035694:web:4a5ca1db22aa34dc3f3abf

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Ubuntu',
          ),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        Home.id: (context) => const Home(),
        CreateEventScreen.id: (context) => CreateEventScreen(),
      },
    );
  }
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    const secondaryColor = Colors.white;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Awesome Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        shadowColor: secondaryColor,
      ),
      home: const HomeScreen(),
    );
  }
}
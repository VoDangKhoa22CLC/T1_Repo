import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/screen/misc/authenticate.dart';
import 'package:lookout_dev/wrapper.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/screen/misc/authenticate.dart';
import 'package:lookout_dev/wrapper.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}

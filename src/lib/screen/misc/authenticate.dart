import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/screen/register.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLogIn = true;
  void toggleView(){
    setState(() {
      isLogIn = !isLogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogIn){
      return LogIn(toggle: toggleView);
    }
    else {
      return Register(toggle: toggleView);
    }
  }
}

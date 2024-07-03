import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/home.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/screen/misc/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final u = 2;

    if (u == 1){
      return Auth();
    }

    if (u == 2){
      return Home();
    }

    else {
      return Placeholder();
    }
    // return Placeholder();
    // return Home();
  }
}

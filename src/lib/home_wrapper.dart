import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/home.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int page = 1;
  void togglePage(targetPage){
    setState(() {
      page = targetPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (page == 1)
      return Home();
    else return Placeholder();
  }
}

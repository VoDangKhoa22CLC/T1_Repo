import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final String userName;
  const UserScreen({super.key, required this.userName});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('User'),
        ),
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
            iconSize: 40,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Text(
              "Event Name:",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )
          ),
          Text(
            widget.userName,
            style: const TextStyle(
                fontSize: 15
            ),
          )
        ],
      ),
    );
  }
}

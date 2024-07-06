import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  final String eventName;
  const EventScreen({super.key, required this.eventName});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('Event'),
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
              widget.eventName,
              style: const TextStyle(
                fontSize: 15
              ),
          )
        ],
      ),
    );
  }
}

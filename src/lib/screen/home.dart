import 'package:flutter/material.dart';
import 'package:lookout_dev/template/event_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.list),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('HCMUS Lookout')
        ),
        backgroundColor: Color.fromRGBO(7, 0, 166, 1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: const Column(
        children: <Widget>[
          EventTile(),
          EventTile(),
          EventTile(),
          EventTile(),
        ],
      ),
    );
  }
}

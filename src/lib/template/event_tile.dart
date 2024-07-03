import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:test_backend/models/school_events.dart';

class EventTile extends StatelessWidget {
  // final MyEvent myEvent;

  const EventTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
          child: InkWell(
            onTap: () => {},
            child: const ListTile(
              leading: Icon(
                Icons.access_time_rounded,
                color: Colors.black,
              ),
              title: Text("Sample Text"),
              subtitle: Text("Sample Info"),
            ),
        ),
      )
    );
  }
}

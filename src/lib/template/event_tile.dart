import 'package:flutter/material.dart';
// import 'package:test_backend/models/school_events.dart';

class EventTile extends StatelessWidget {
  // final MyEvent myEvent;
  final String EventName;

  const EventTile({super.key, required this.EventName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
          child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: const Icon(
                Icons.access_time_rounded,
                color: Colors.black,
              ),
              title: Text(this.EventName),
              subtitle: Text("Sample Info"),
            ),
        ),
      )
    );
  }
}

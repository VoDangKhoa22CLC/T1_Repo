import 'package:flutter/material.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/event_screen.dart';
// import 'package:test_backend/models/school_events.dart';

class EventTile extends StatelessWidget {
  // final MyEvent myEvent;
  final EventClass myEvent;

  const EventTile({super.key, required this.myEvent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventScreen(myEvent: myEvent,))
              );
            },
            child: ListTile(
              leading: const Icon(
                Icons.access_time_rounded,
                color: Colors.black,
              ),
              title: Text(myEvent.eventName),
              subtitle: const Text("Sample Info"),
            ),
        ),
      )
    );
  }
}

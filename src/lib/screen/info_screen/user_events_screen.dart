import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:lookout_dev/data/event_class.dart';

import '../../data/account_class.dart';

class UserEventsScreen extends StatefulWidget {
  final Club myClub;
  const UserEventsScreen({super.key, required this.myClub});

  @override
  State<UserEventsScreen> createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {

  List<EventClass> events = <EventClass>[];
  final _eventController = EventController();

  Future _getAllRelatedEvents() async{
    List<EventClass> eventsNew = <EventClass>[];
    List<String>? idList = await AccountController().relatedEvents;
    if (idList != null){
      for (String s in idList){
        EventClass? ev = await _eventController.getEvent(eventID: s);
        if (ev != null) {
          eventsNew.add(ev as EventClass);
        }
      }
    }
    setState(() {
      events = eventsNew;
    });
  }


  @override
  void initState() {
    super.initState();
    _getAllRelatedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Events'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.eventName),
            subtitle: Text(event.eventTime),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Placeholder
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Placeholder
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted ${event.eventName}')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

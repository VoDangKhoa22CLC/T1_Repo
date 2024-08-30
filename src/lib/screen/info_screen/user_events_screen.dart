import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/event_edit.dart';

import '../../data/account_class.dart';

class UserEventsScreen extends StatefulWidget {
  final String isAdmin;
  const UserEventsScreen({super.key, required this.isAdmin});

  @override
  State<UserEventsScreen> createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  List<EventClass> events = <EventClass>[];
  final _eventController = EventController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  Future _getAllRelatedEvents() async{
    List<EventClass> eventsNew = <EventClass>[];
    List<String>? idList = await AccountController().relatedEvents;
    if (idList != null){
      for (String s in idList){
        EventClass? ev = await _eventController.getEvent(eventID: s);
        if (ev != null) {
          eventsNew.add(ev);
        }
      }
    }
    setState(() {
      events = eventsNew;
    });
  }

  Future _getAllEvents() async {
    List<EventClass> eventsNew = await _eventController.getAllEvents();

    setState(() {
      events = eventsNew;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin == "true"){
      _getAllEvents();
    }
    else {
      _getAllRelatedEvents();
    }
  }

  Widget _deletePrompt({required EventClass thisEvent}){
    return AlertDialog(
      title: const Text("Delete Event"),
      content: const Text("Remove this event? (This action can't be undone)"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without saving
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _eventController.deleteEvent(eventID: thisEvent.eventID);
            // do some saving action here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted ${thisEvent.eventName}')),
            );
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Events'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        strokeWidth: 2.0,
        onRefresh: () async {
          if (widget.isAdmin == "true"){
            _getAllEvents();
          }
          else {
            _getAllRelatedEvents();
          }
        },
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventEditScreen(myEvent: event),
                        )
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(context: context, builder:(BuildContext context) {return _deletePrompt(thisEvent: event);} );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

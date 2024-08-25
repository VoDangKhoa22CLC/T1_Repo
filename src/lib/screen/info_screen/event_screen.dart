import 'package:flutter/material.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/event_edit.dart';

class EventScreen extends StatefulWidget {
  final EventClass myEvent;
  const EventScreen({super.key, required this.myEvent});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  bool isFollowed = false;
  DateTime startDate = DateTime.now();
  
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Event Info:",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Text(widget.myEvent.eventName),
                  subtitle: const Text("Event Organization"),
                ),
              ),
              Card(
                color: Colors.blueGrey[80],
                margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(startDate.toString()),
                      const Text(
                        "Event Description. Event Description. Event Description. Event Description. Event Description. Event Description."
                        "Event Description. Event Description. Event Description. Event Description. Event Description. Event Description."
                        "Event Description. Event Description. Event Description. Event Description. Event Description. Event Description. ",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            isFollowed = !isFollowed;
                          });
                        },
                        icon: isFollowed ? const Icon(Icons.notifications_off) : const Icon(Icons.notification_add),
                        label: Text(
                          isFollowed ? "Unfollow this event" : "Follow this event",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EventEditPage(eventName: widget.myEvent.eventName))
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label : const Text("Edit this event")
                      )
                    ],
                  ),
                ),
              )/**/
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_storage/firebase_storage.dart';
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
  final List<String> _urls = <String>["", "", ""];


  Future _loadImage(String inputURL, int index) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urls[index] = url;
    });
  }

  @override
  void initState(){
    super.initState();

    if (widget.myEvent.eventImage1 != '') {
      setState(() {
        _loadImage(widget.myEvent.eventImage1, 0);
      });
    }
    if (widget.myEvent.eventImage2 != '') {
      setState(() {
        _loadImage(widget.myEvent.eventImage2, 1);
      });
    }
    if (widget.myEvent.eventImage3 != '') {
      setState(() {
        _loadImage(widget.myEvent.eventImage3, 2);
      });
    }

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('Event'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                  subtitle: Text(widget.myEvent.hostID),
                ),
              ),
              SizedBox(
                width: 400,
                child: Card(
                  color: Colors.blueGrey[80],
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.myEvent.eventID),
                        Text(widget.myEvent.eventLongDescription,
                          style: const TextStyle(
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
                                MaterialPageRoute(builder: (context) => EventEditScreen(myEvent: widget.myEvent))
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label : const Text("Edit this event")
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _urls[0] != "" ? Image(image: NetworkImage(_urls[0]), width: 120, height: 120) : const SizedBox(width: 120, height: 120),
                  _urls[1] != "" ? Image(image: NetworkImage(_urls[1]), width: 120, height: 120) : const SizedBox(width: 120, height: 120),
                  _urls[2] != "" ? Image(image: NetworkImage(_urls[2]), width: 120, height: 120) : const SizedBox(width: 120, height: 120),
                ],
              )/**/
            ],
          ),
        ),
      ),
    );
  }
}

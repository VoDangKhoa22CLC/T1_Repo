import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/template/event_tile.dart';
import 'package:provider/provider.dart';

class EventController {
  final CollectionReference _firestore = FirebaseFirestore.instance.collection('events');

  Future<EventClass?> createEvent({
    required String eventName,
    required String eventTime,
    required String eventLocation,
    required String eventShortDescription,
    required String eventLongDescription,
    required String hostID,
  }) async {
    EventClass event = EventClass(hostID: hostID, eventName: eventName, eventTime: eventTime, eventLocation: eventLocation, eventShortDescription: eventShortDescription, eventLongDescription: eventLongDescription);

    await _firestore.add(event.toMap());
    return event;
  }

  void deleteEvent({
    required String eventID
  }) async {
    await _firestore.doc(eventID).set({

    });
  }

  Future<EventClass?> editEvent({
    required String eventID,
    required String eventName,
    required String eventTime,
    required String eventLocation,
    required String eventShortDescription,
    required String eventLongDescription,
    required String hostID,
  }) async {
    EventClass event = EventClass(hostID: hostID, eventName: eventName, eventTime: eventTime, eventLocation: eventLocation, eventShortDescription: eventShortDescription, eventLongDescription: eventLongDescription);

    await _firestore.doc(eventID).set(event.toMap());
    return event;
  }

  Future<EventClass?> getEvent({
    required String eventID
  }) async {
    DocumentSnapshot eventDoc = await _firestore.doc(eventID).get();
    Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;

    return EventClass.fromMap(data);
  }

  List<EventClass> _eventsFromSnapShot(QuerySnapshot snap){
    return snap.docs.map((e){
      return EventClass(
        hostID: e.get('hostID'),
        eventName: e.get('eventName'),
        eventTime: e.get('eventTime'),
        eventLocation: e.get('eventLocation'),
        eventShortDescription: e.get('eventShortDescription'),
        eventLongDescription: e.get('eventLongDescription')
      );
    }).toList();
  }

  Stream<List<EventClass>> get events{
    return _firestore.snapshots().map(_eventsFromSnapShot);
  }
}


class EventList extends StatefulWidget {
  final String search_query;

  const EventList({super.key, required this.search_query});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventClass>?>(context);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: events != null ? events.length : 0,
      itemBuilder: (context, index){
        return events![index].eventName.contains(widget.search_query) ? EventTile(myEvent: events[index]) : const Placeholder();
      }
    );
  }
}

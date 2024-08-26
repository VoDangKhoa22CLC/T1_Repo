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
    EventClass event = EventClass(
      eventID: "",
      hostID: hostID,
      eventName: eventName,
      eventTime: eventTime,
      eventLocation: eventLocation,
      eventShortDescription: eventShortDescription,
      eventLongDescription: eventLongDescription
    );

    DocumentReference docRef = await _firestore.add(event.toMap());
    event.eventID = docRef.id;
    _firestore.doc(event.eventID).set({'eventID': event.eventID}, SetOptions(merge: true));
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
    EventClass event = EventClass(
      eventID: eventID,
      hostID: hostID,
      eventName: eventName,
      eventTime: eventTime,
      eventLocation: eventLocation,
      eventShortDescription: eventShortDescription,
      eventLongDescription: eventLongDescription
    );

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
        eventID: e.get('eventID'),
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
  final String searchQuery;

  const EventList({super.key, required this.searchQuery});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventClass>?>(context);
    final filtered = events?.where((event) => event.eventName.contains(widget.searchQuery)).toList();

    ListView listView = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: events != null ? events.length : 0,
      itemBuilder: (context, index){
        return EventTile(myEvent: events![index]);
      }
    );

    ListView filteredView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: filtered != null ? filtered.length : 0,
        itemBuilder: (context, index){
          return EventTile(myEvent: filtered![index]);
        }
    );

    return widget.searchQuery.isEmpty ? listView : filteredView;
  }
}

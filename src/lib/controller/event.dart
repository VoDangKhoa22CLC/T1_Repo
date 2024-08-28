import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/template/event_tile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventController {
  final CollectionReference _firestore = FirebaseFirestore.instance.collection('events');
  final Reference _storage = FirebaseStorage.instance.ref();
  String path1 = "";
  String path2 = "";
  String path3 = "";

  Future<EventClass?> createEvent({
    required String eventName,
    required String eventTime,
    required String eventLocation,
    required String eventShortDescription,
    required String eventLongDescription,
    required String hostID,
    required PlatformFile? img1,
    required PlatformFile? img2,
    required PlatformFile? img3
  }) async {

    EventClass event = EventClass(
      eventID: "",
      hostID: hostID,
      eventName: eventName,
      eventTime: eventTime,
      eventLocation: eventLocation,
      eventShortDescription: eventShortDescription,
      eventLongDescription: eventLongDescription,
      eventImage1: path1,
      eventImage2: path2,
      eventImage3: path3,
      subscribers: 0
    );

    DocumentReference docRef = await _firestore.add(event.toMap());
    event.eventID = docRef.id;

    if (img1 != null){
      path1 = "pictures/${event.eventID}/${img1.name}";
      final refPic1 = _storage.child(path1);
      refPic1.putFile(File(img1.path!));
    }

    if (img2 != null){
      path2 = "pictures/${event.eventID}/${img2.name}";
      final refPic2 = _storage.child(path2);
      refPic2.putFile(File(img2.path!));
    }

    if (img3 != null){
      path3 = "pictures/${event.eventID}/${img3.name}";
      final refPic3 = _storage.child(path3);
      refPic3.putFile(File(img3.path!));
    }
    _firestore.doc(event.eventID).set({'eventID': event.eventID, 'eventImage1': path1, 'eventImage2': path2, 'eventImage3':path3}, SetOptions(merge: true));
    return event;
  }

  void deleteEvent({
    required String eventID
  }) async {
    await _firestore.doc(eventID).delete();
  }

  Future<EventClass?> editEvent({
    required String eventID,
    required String eventName,
    required String eventTime,
    required String eventLocation,
    required String eventShortDescription,
    required String eventLongDescription,
    required String hostID,
    required String img1,
    required String img2,
    required String img3,
    required int subscribers,
  }) async {
    EventClass event = EventClass(
      eventID: eventID,
      hostID: hostID,
      eventName: eventName,
      eventTime: eventTime,
      eventLocation: eventLocation,
      eventShortDescription: eventShortDescription,
      eventLongDescription: eventLongDescription,
      eventImage1: img1,
      eventImage2: img2,
      eventImage3: img3,
      subscribers: subscribers,
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
        eventLongDescription: e.get('eventLongDescription'),
        eventImage1: e.get('eventImage1'),
        eventImage2: e.get('eventImage2'),
        eventImage3: e.get('eventImage3'),
        subscribers: e.get('subscribers')
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




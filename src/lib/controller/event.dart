import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/template/event_tile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/account_class.dart';

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
      path1 = "pictures/event/${event.eventID}/${img1.name}";
      final refPic1 = _storage.child(path1);
      refPic1.putFile(File(img1.path!));
    }

    if (img2 != null){
      path2 = "pictures/event/${event.eventID}/${img2.name}";
      final refPic2 = _storage.child(path2);
      refPic2.putFile(File(img2.path!));
    }

    if (img3 != null){
      path3 = "pictures/event/${event.eventID}/${img3.name}";
      final refPic3 = _storage.child(path3);
      refPic3.putFile(File(img3.path!));
    }

    AccountController().appendEvents(event.eventID);

    _firestore.doc(event.eventID).set({'eventID': event.eventID, 'eventImage1': path1, 'eventImage2': path2, 'eventImage3':path3}, SetOptions(merge: true));
    return event;
  }

  Future deleteEvent({
    required String eventID
  }) async {
    final snapshots = FirebaseFirestore.instance.collection('users');
    final stuff = await snapshots.get();
    final accounts = stuff.docs.map((doc) => doc.data());
    List<String> ls = [];
    String field = "";

    for (Map<String, dynamic> acc in accounts){
      if (acc['userType'] == UserType.Student.toString()){
        field = "attendedEventIds";
      }
      else if (acc['userType'] == UserType.Club.toString()){
        field = "hostedEventIds";
      }

      if (field != "") {
        ls = List<String>.from(acc[field]);
        ls.remove(eventID);
        await snapshots.doc(acc['uid']).set({field : ls}, SetOptions(merge: true));
      }
    }

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
    required int subscribers,
  }) async {
    DocumentSnapshot dc = await _firestore.doc(eventID).get();
    Map<String, dynamic> thisEvent = dc.data() as Map<String, dynamic>;
    EventClass event = EventClass(
      eventID: eventID,
      hostID: hostID,
      eventName: eventName,
      eventTime: eventTime,
      eventLocation: eventLocation,
      eventShortDescription: eventShortDescription,
      eventLongDescription: eventLongDescription,
      eventImage1: thisEvent['eventImage1'],
      eventImage2: thisEvent['eventImage2'],
      eventImage3: thisEvent['eventImage3'],
      subscribers: subscribers,
    );

    await _firestore.doc(eventID).set(event.toMap());
    return event;
  }

  Future editImages(String eventID, int imageIndex, String changes, PlatformFile? newImage) async{
    String newImgPath = "";

    if (changes == "delete"){
      newImgPath = "";
    }
    else if ((changes == "new") & (newImage != null)){
      newImgPath = "pictures/event/$eventID/${newImage?.name}";
      final refPic = _storage.child(newImgPath);
      refPic.putFile(File(newImage!.path!));
    }

    await _firestore.doc(eventID).set({'eventImage${imageIndex + 1}' : newImgPath}, SetOptions(merge: true));
  }

  Future<EventClass?> getEvent({
    required String eventID
  }) async {
    DocumentSnapshot eventDoc = await _firestore.doc(eventID).get();
    Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;

    return EventClass.fromMap(data);
  }

  Future<List<EventClass>> getAllEvents() async {
    final snapshots = FirebaseFirestore.instance.collection('events');
    final stuff = await snapshots.get();
    final allEvents = stuff.docs.map((doc) => doc.data());

    List<EventClass> eventList = allEvents.map(EventClass.fromMap).toList();
    return eventList;
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
  final String sortQuery;

  const EventList({super.key, required this.searchQuery, required this.sortQuery});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventClass>?>(context);
    if (widget.sortQuery == "Time↓") {
      events?.sort((a, b) => a.eventTime.compareTo(b.eventTime));
    }
    else if (widget.sortQuery == "Time↑"){
      events?.sort((a, b) => b.eventTime.compareTo(a.eventTime));
    }

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




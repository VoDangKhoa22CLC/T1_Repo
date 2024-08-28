import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:lookout_dev/data/event_class.dart';

class EventEditScreen extends StatefulWidget {
  static const String id = 'edit_event_screen';
  final EventClass myEvent;

  EventEditScreen({super.key, required this.myEvent});

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _eventDescription = '';
  DateTime _eventDate = DateTime(2024);
  String _eventLocation = '';
  String _eventNotes = '';
  final EventController eventController = EventController();
  List<PlatformFile?> _pickedImage = <PlatformFile?>[null, null, null];
  final List<String> _urls = <String>["", "", ""];

  void _editEvent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // create event riel here
      eventController.editEvent(
        eventID: widget.myEvent.eventID,
        eventName: _eventName,
        eventTime: _eventDate.toString(),
        eventLocation: _eventLocation,
        eventShortDescription: _eventNotes,
        eventLongDescription: _eventDescription,
        hostID: widget.myEvent.hostID,
        subscribers: widget.myEvent.subscribers,
      );
      // after creating, return to home or pop a noti
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future _selectPicture(int picIndex) async {
    final res = await FilePicker.platform.pickFiles();

    if (res == null) return;

    setState(() {
      _pickedImage[picIndex] = res.files.first;
    });
  }

  Future _unselectPicture(int picIndex) async {
    setState(() {
      if (_pickedImage[picIndex] != null) {
        _pickedImage[picIndex] = null;
      }
      else {
        _urls[0] = "";
      }
    });
  }

  Future _loadImage(String inputURL, int index) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urls[index] = url;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: widget.myEvent.eventName,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value!;
                },
              ),
              TextFormField(
                initialValue: widget.myEvent.eventLongDescription,
                decoration: const InputDecoration(labelText: 'Event Description'),
                onSaved: (value) {
                  _eventDescription = value!;
                },
              ),
              TextFormField(
                initialValue: widget.myEvent.eventLocation,
                decoration: const InputDecoration(labelText: 'Event Location'),
                onSaved: (value) {
                  _eventLocation = value!;
                },
              ),
              TextFormField(
                initialValue: widget.myEvent.eventShortDescription,
                decoration: const InputDecoration(labelText: 'Event Notes'),
                onSaved: (value) {
                  _eventNotes = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Date: ${_eventDate.toLocal()}'.split(' ')[0],
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _pickedImage[0] != null ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(File(_pickedImage[0]!.path!), width: 120, height: 120,),
                        IconButton(
                          onPressed: (){_unselectPicture(0);},
                          icon: const Icon(Icons.motion_photos_off_outlined),
                          color: Colors.white,
                        ),
                      ]
                  ) :
                      _urls[0] != "" ?
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(_urls[0]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: (){_selectPicture(0);},
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                          ),
                          IconButton(
                            onPressed: (){_unselectPicture(0);},
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                          )
                        ],
                      )
                    ],
                  ) :
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(width: 120, height: 120),
                      IconButton(
                        onPressed: (){_selectPicture(0);},
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      )
                    ],
                  ),
                  _pickedImage[1] != null ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(File(_pickedImage[1]!.path!), width: 120, height: 120,),
                        IconButton(
                          onPressed: (){_unselectPicture(1);},
                          icon: const Icon(Icons.motion_photos_off_outlined),
                          color: Colors.white,
                        ),
                      ]
                  ) : _urls[1] != "" ?
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(_urls[1]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: (){_selectPicture(1);},
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                            ),
                            IconButton(
                              onPressed: (){_unselectPicture(1);},
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                            )
                          ],
                        )
                      ],
                    ) :
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(width: 120, height: 120),
                      IconButton(
                        onPressed: (){_selectPicture(1);},
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      )
                    ],
                  ),
                  _pickedImage[2] != null ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(File(_pickedImage[2]!.path!), width: 120, height: 120,),
                      IconButton(
                        onPressed: (){_unselectPicture(2);},
                        icon: const Icon(Icons.motion_photos_off_outlined),
                        color: Colors.white,
                      ),
                    ]
                  ) : _urls[2] != "" ?
                    Stack(
                      alignment: Alignment.center,
                      children: [
                      Image.network(_urls[2]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: (){_selectPicture(2);},
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                            ),
                            IconButton(
                              onPressed: (){_unselectPicture(2);},
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                            )
                          ],
                      )
                    ],
                    ) : Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(width: 120, height: 120),
                      IconButton(
                        onPressed: (){_selectPicture(2);},
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      )
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _editEvent();
                  for (int i = 0; i < 3; i++){
                    if (_urls[i] == ""){
                      if (_pickedImage[i] != null) {
                        eventController.editImages(widget.myEvent.eventID, i, "new", _pickedImage[i]);
                      } else{
                        eventController.editImages(widget.myEvent.eventID, i, "delete", null);
                      }
                    }
                  }
                },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

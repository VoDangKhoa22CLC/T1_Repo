import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lookout_dev/data/account_class.dart';

import '../../data/event_class.dart';

class CreateEventScreen extends StatefulWidget {
  static const String id = 'create_event_screen';

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _eventDescription = '';
  DateTime _eventDate = DateTime(2024);
  String _eventLocation = '';
  String _eventNotes = '';
  final EventController eventController = EventController();
  List<PlatformFile?> _pickedImage = <PlatformFile?>[null, null, null];

  Future _selectPicture(int picIndex) async {
    final res = await FilePicker.platform.pickFiles();

    if (res == null) return;

    setState(() {
      _pickedImage[picIndex] = res.files.first;
    });
  }

  Future _unselectPicture(int picIndex) async {
    setState(() {
      _pickedImage[picIndex] = null;
    });
  }

  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
       AppUser? currentUser = await AccountController().getCurrentUser();
      _formKey.currentState!.save();
      // create event riel here
      EventClass ev = eventController.createEvent(
        eventName: _eventName,
        eventTime: _eventDate.toString(),
        eventLocation: _eventLocation,
        eventShortDescription: _eventNotes,
        eventLongDescription: _eventDescription,
        hostID: currentUser!.uid,
        img1: _pickedImage[0],
        img2: _pickedImage[1],
        img3: _pickedImage[2],
      ) as EventClass;
      AccountController().appendEvents(ev.eventID);
      // after creating, return to home or pop a noti
      if (context.mounted) Navigator.of(context).pop();
    }
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
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('Create Event'),
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
                decoration: InputDecoration(labelText: 'Event Name'),
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
                decoration: InputDecoration(labelText: 'Event Description'),
                onSaved: (value) {
                  _eventDescription = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Location'),
                onSaved: (value) {
                  _eventLocation = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Notes'),
                onSaved: (value) {
                  _eventNotes = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    _eventDate == null
                        ? 'Select Date'
                        : 'Date: ${_eventDate!.toLocal()}'.split(' ')[0],
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _pickedImage[0] != null ? Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(File(_pickedImage[0]!.path!), width: 120, height: 120,),
                        IconButton(
                          onPressed: (){_unselectPicture(0);},
                          icon: const Icon(Icons.motion_photos_off_outlined),
                          color: Colors.white,
                        ),
                      ]
                    ),
                  ) :
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 120, height: 120),
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
                  ) :
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 120, height: 120),
                      IconButton(
                        onPressed: (){_selectPicture(1);},
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      )
                    ],
                  ),
                  _pickedImage[2] != null ? Container(
                    child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(File(_pickedImage[2]!.path!), width: 120, height: 120,),
                          IconButton(
                            onPressed: (){_unselectPicture(2);},
                            icon: const Icon(Icons.motion_photos_off_outlined),
                            color: Colors.white,
                          ),
                        ]
                    ),
                  ) :
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 120, height: 120),
                      IconButton(
                        onPressed: (){_selectPicture(2);},
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Create Event', 
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

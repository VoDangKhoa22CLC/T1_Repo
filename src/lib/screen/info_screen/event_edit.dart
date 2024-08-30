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
  DateTime _eventDate = DateTime.now().add(const Duration(days: 1));
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

  InputDecoration _textFormInputDecoration(String labelText)  {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black87),
      filled: true,
      fillColor: Colors.blue[50],
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
      ),
    );
  }

  Widget _getUserImageInput(int index){
    return _pickedImage[index] != null ? Flexible(
      child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(File(_pickedImage[index]!.path!), width: 120, height: 120,),
            IconButton(
              onPressed: (){_unselectPicture(index);},
              icon: const Icon(Icons.cancel_outlined, color: Colors.black,),
              style: IconButton.styleFrom(backgroundColor: Colors.white),
            ),
          ]
      ),
    ) : _urls[index] != "" ?
    Flexible(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(_urls[index]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: (){_selectPicture(index);},
                icon: const Icon(Icons.change_circle_outlined, color: Colors.black,),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
              IconButton(
                onPressed: (){_unselectPicture(index);},
                icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              )
            ],
          )
        ],
      ),
    ) :
    Flexible(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(width: 120, height: 120),
          IconButton(
            onPressed: (){_selectPicture(index);},
            icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.black),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                minLines: 1,
                maxLines: 2,
                cursorColor: Theme.of(context).primaryColor,
                decoration: _textFormInputDecoration('Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value!;
                },
              ),
                const SizedBox(height: 10),
                // Enter event location
                TextFormField(
                  initialValue: widget.myEvent.eventLocation,
                  minLines: 1,
                  maxLines: 2,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: _textFormInputDecoration('Event Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event location.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _eventLocation = value!;
                  },
                ),
                const SizedBox(height: 10),
                // Enter event description
                TextFormField(
                  initialValue: widget.myEvent.eventLongDescription,
                  minLines: 1,
                  maxLines: 4,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: _textFormInputDecoration('Event Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event description.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _eventDescription = value!;
                  },
                ),
                const SizedBox(height: 10),
                // Enter event notes
                TextFormField(
                  initialValue: widget.myEvent.eventShortDescription,
                  minLines: 1,
                  maxLines: 2,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: _textFormInputDecoration('Event Notes'),
                  onSaved: (value) {
                    _eventNotes = value!;
                  },
                ),
                const SizedBox(height: 10),
                // Select Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getUserImageInput(0),
                  _getUserImageInput(1),
                  _getUserImageInput(2)
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _editEvent();
                  for (int i = 0; i < 3; i++){
                    if (_pickedImage[i] != null){
                      eventController.editImages(widget.myEvent.eventID, i, "new", _pickedImage[i]);
                    }
                    else if (_urls[i] == ""){
                      eventController.editImages(widget.myEvent.eventID, i, "delete", null);
                    }
                  }
                },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

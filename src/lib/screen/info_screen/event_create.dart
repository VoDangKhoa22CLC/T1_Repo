import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lookout_dev/data/account_class.dart';

import '../../data/event_class.dart';

class CreateEventScreen extends StatefulWidget {
  static const String id = 'create_event_screen';
  final Club myClub;

  const CreateEventScreen({super.key, required this.myClub});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _eventDescription = '';
  DateTime _eventDate = DateTime.now().add(const Duration(days: 1));
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

  void _createEvent(){
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // create event riel here
      eventController.createEvent(
        eventName: _eventName,
        eventTime: _eventDate.toString(),
        eventLocation: _eventLocation,
        eventShortDescription: _eventNotes,
        eventLongDescription: _eventDescription,
        hostID: widget.myClub.uid,
        img1: _pickedImage[0],
        img2: _pickedImage[1],
        img3: _pickedImage[2],
      );
      Navigator.pop(context);
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Enter event name
                TextFormField(
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
                TextFormField(
                  controller: TextEditingController(text: _eventDate.toLocal().toString().split(' ')[0]),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    labelStyle: const TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.blue[50],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value != null) {
                      String year = value.split('-')[0];
                      String month = value.split('-')[1];
                      String day = value.split('-')[2];
                      if ((int.parse(year) < DateTime.now().year) ||
                          (int.parse(year) == DateTime.now().year && int.parse(month) < DateTime.now().month) ||
                          (int.parse(year) == DateTime.now().year && int.parse(month) == DateTime.now().month && int.parse(day) < DateTime.now().day)
                          )
                        return 'Please enter a valid date';
                      return null;
                    }
                  },
                ),
                // Add image section
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _pickedImage[0] != null ? Flexible(
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
                    Flexible(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(width: 120, height: 120),
                          IconButton(
                            onPressed: (){_selectPicture(0);},
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                          )
                        ],
                      ),
                    ),
                    _pickedImage[1] != null ? Flexible(
                      child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.file(File(_pickedImage[1]!.path!), width: 120, height: 120,),
                            IconButton(
                              onPressed: (){_unselectPicture(1);},
                              icon: const Icon(Icons.motion_photos_off_outlined),
                              color: Colors.white,
                            ),
                          ]
                      ),
                    ) :
                    Flexible(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(width: 120, height: 120),
                          IconButton(
                            onPressed: (){_selectPicture(1);},
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                          )
                        ],
                      ),
                    ),
                    _pickedImage[2] != null ? Flexible(
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
                    Flexible(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(width: 120, height: 120),
                          IconButton(
                            onPressed: (){_selectPicture(2);},
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Create Event',
                    style: TextStyle(color: Colors.black87), 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

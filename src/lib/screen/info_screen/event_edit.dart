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

  void _editEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // create event riel here
      EventClass? thisEvent = await EventController().getEvent(eventID: widget.myEvent.eventID);
      eventController.editEvent(
        eventID: widget.myEvent.eventID,
        eventName: _eventName,
        eventTime: _eventDate.toString(),
        eventLocation: _eventLocation,
        eventShortDescription: _eventNotes,
        eventLongDescription: _eventDescription,
        hostID: thisEvent!.hostID,
        img1: widget.myEvent.eventImage1,
        img2: widget.myEvent.eventImage2,
        img3: widget.myEvent.eventImage3,
        subscribers: thisEvent.subscribers,
      );
      // after creating, return to home or pop a noti
      if (mounted){
        Navigator.pop(context);
        Navigator.pop(context);
      }
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
                decoration: InputDecoration(labelText: 'Event Description'),
                onSaved: (value) {
                  _eventDescription = value!;
                },
              ),
              TextFormField(
                initialValue: widget.myEvent.eventLocation,
                decoration: InputDecoration(labelText: 'Event Location'),
                onSaved: (value) {
                  _eventLocation = value!;
                },
              ),
              TextFormField(
                initialValue: widget.myEvent.eventShortDescription,
                decoration: InputDecoration(labelText: 'Event Notes'),
                onSaved: (value) {
                  _eventNotes = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Date: ${_eventDate.toLocal()}'.split(' ')[0],
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _editEvent,
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

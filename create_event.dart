import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  static const String id = 'create_event_screen';

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _eventDescription = '';
  DateTime? _eventDate;
  String _eventLocation = '';
  String _eventNotes = '';

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // create event riel here

      // after creating, return to home or pop a noti
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
        backgroundColor: Colors.deepPurple,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, 
                ),
                child: Text(
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

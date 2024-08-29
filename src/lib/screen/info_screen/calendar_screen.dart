import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:lookout_dev/screen/info_screen/credits.dart';
import 'package:lookout_dev/template/event_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _eventsIds = [];
  Map<DateTime, List<EventTile>> eventsAtDay = {};
  late final ValueNotifier<List<EventTile>> _selectedEvents;

  List<EventTile> _getEventsForDay(DateTime day) {
    //get all events from the selected day
    return eventsAtDay[day] ?? []; // if date time not found then return an empty list
  }

  // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  // if (!isSameDay(_selectedDay, selectedDay)) {
  //   setState(() {
  //     _focusedDay = focusedDay;
  //     _selectedDay = selectedDay;
  //     _selectedEvents = _getEventsForDay(selectedDay);
  //     });
  //   }
  // }

  void _getEventsList() async{
    _eventsIds = (await AccountController().relatedEvents)!;
    EventController eventController = EventController();
    Map<DateTime, List<EventTile>> eventTileMap = {};
    for (String eventID in _eventsIds){
      EventClass? thisEvent = await eventController.getEvent(eventID: eventID);
      if (thisEvent != null){
        if (!eventTileMap.containsKey(DateTime.parse("${thisEvent.eventTime}Z").copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0))) {
          eventTileMap[DateTime.parse("${thisEvent.eventTime}Z").copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0)] = <EventTile>[EventTile(myEvent: thisEvent)];
        }
        else {
          eventTileMap[DateTime.parse("${thisEvent.eventTime}Z").copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0)]?.add(EventTile(myEvent: thisEvent));
        }
      }
    }
    setState(() {
      eventsAtDay = eventTileMap;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _getEventsList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      //this button simply add a sample event to the current selected day, for testing.
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     // setState(() {
      //     //   if (!eventsAtDay.containsKey(_selectedDay)) {
      //     //     eventsAtDay[_selectedDay!] = [];
      //     //   }
      //     //   eventsAtDay[_selectedDay!]!.add(EventTile(eventName: 'Event'));
      //     //   _selectedEvents.value = _getEventsForDay(_selectedDay!);
      //     // });
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2010, 10, 20),
            lastDay: DateTime(2040, 10, 20),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.
              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents.value = _getEventsForDay(selectedDay);
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
          ),
          Expanded(
            child: 
            ValueListenableBuilder<List<EventTile>>(valueListenable: _selectedEvents, builder: (context, value, _){
              return ListView.builder(itemCount: value.length, itemBuilder: (context, index){
                return value[index];
              });  
            })
          ),
        ]
      ),
    );  
  }
}

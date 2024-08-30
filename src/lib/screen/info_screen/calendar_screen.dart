import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  //     _selectedEvents   = _getEventsForDay(selectedDay);
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
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
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
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true, // Center the title (current month/year)
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  if (events.length > 4) {
                    // Show the number of events when there are more than 4
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          '${events.length}', // Display the number of events
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Show dots for 4 or fewer events
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(events.length, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.5),
                            width: 6.0,
                            height: 6.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    );
                  }
                }
                return null; // No events, no marker
              },
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor, 
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Colors.white, 
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
           // Adding a thin line separator
          SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width * 0.6, // 60% of the screen width
            child: Divider(
              height: 1,
              thickness: 3,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4),
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

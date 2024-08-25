class EventClass{
  final String hostID;
  final String eventName;
  final String eventTime;
  final String eventLocation;
  final String eventShortDescription;
  final String eventLongDescription;

  EventClass({
    required this.hostID,
    required this.eventName,
    required this.eventTime,
    required this.eventLocation,
    required this.eventShortDescription,
    required this.eventLongDescription
  });

  Map<String, dynamic> toMap(){
    return {
      'hostID': hostID,
      'eventName': eventName,
      'eventTime': eventTime,
      'eventLocation': eventLocation,
      'eventShortDescription': eventShortDescription,
      'eventLongDescription': eventLongDescription,
    };
  }

  factory EventClass.fromMap(Map<String, dynamic> map){
    return EventClass(
        hostID: map['hostID'],
        eventName: map['eventName'],
        eventTime: map['eventTime'],
        eventLocation: map['eventLocation'],
        eventShortDescription: map['eventShortDescription'],
        eventLongDescription: map['eventLongDescription']
    );
  }
}
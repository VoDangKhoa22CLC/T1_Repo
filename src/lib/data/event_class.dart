class EventClass{
  String eventID = "";
  final String hostID;
  final String eventName;
  final String eventTime;
  final String eventLocation;
  final String eventShortDescription;
  final String eventLongDescription;

  EventClass({
    required this.eventID,
    required this.hostID,
    required this.eventName,
    required this.eventTime,
    required this.eventLocation,
    required this.eventShortDescription,
    required this.eventLongDescription
  });



  Map<String, dynamic> toMap(){
    return {
      'eventID': eventID,
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
      eventID: map['eventID'],
      hostID: map['hostID'],
      eventName: map['eventName'],
      eventTime: map['eventTime'],
      eventLocation: map['eventLocation'],
      eventShortDescription: map['eventShortDescription'],
      eventLongDescription: map['eventLongDescription']
    );
  }
}
class EventClass{
  String eventID = "";
  final String hostID;
  final String eventName;
  final String eventTime;
  final String eventLocation;
  final String eventShortDescription;
  final String eventLongDescription;
  final String eventImage1;
  final String eventImage2;
  final String eventImage3;

  EventClass({
    required this.eventID,
    required this.hostID,
    required this.eventName,
    required this.eventTime,
    required this.eventLocation,
    required this.eventShortDescription,
    required this.eventLongDescription,
    required this.eventImage1,
    required this.eventImage2,
    required this.eventImage3,
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
      'eventImage1': eventImage1,
      'eventImage2': eventImage2,
      'eventImage3': eventImage3
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
      eventLongDescription: map['eventLongDescription'],
      eventImage1: map['eventImage1'],
      eventImage2: map['eventImage2'],
      eventImage3: map['eventImage3'],
    );
  }
}
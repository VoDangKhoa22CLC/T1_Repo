import 'package:flutter/services.dart';

enum UserType { Student, Club }

// Base User class
class AppUser {
  final String uid;
  String email;
  String name;
  final UserType userType;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.userType,
    //this.profilePicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'userType': userType.toString(),
      //'profile_picture': profilePicture,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      userType:
          UserType.values.firstWhere((e) => e.toString() == map['userType']),
      //profilePicture: map['profile_picture'],
    );
  }

  static Future<Uint8List> loadDefaultProfilePicture() async {
    ByteData data = await rootBundle.load('assets/images/dummy.png');
    return data.buffer.asUint8List();
  }

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }
}

// Student class
class Student extends AppUser {
  final String? studentId;
  final String? major;
  final List<String>? attendedEventIds;

  Student({
    required super.uid,
    required super.email,
    required super.name,
    //super.profilePicture,
    this.studentId = '',
    this.major = '',
    this.attendedEventIds = const [],
  }) : super(userType: UserType.Student);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'studentId': studentId,
      'major': major,
      'attendedEventIds': attendedEventIds,
    });
    return map;
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      //profilePicture: map['profile_picture'],
      studentId: map['studentId'],
      major: map['major'],
      attendedEventIds: List<String>.from(map['attendedEventIds'] ?? []),
    );
  }
}

// Club class
class Club extends AppUser {
  final String? description;
  final List<String>? hostedEventIds;
  final String profilePicture;
  final String profileImage1;
  final String profileImage2;
  final String profileImage3;
  final String verified;

  Club({
    required super.uid,
    required super.email,
    required super.name,
    this.description = '',
    this.hostedEventIds = const [],
    required this.profilePicture,
    required this.profileImage1,
    required this.profileImage2,
    required this.profileImage3,
    required this.verified,
  }) : super(userType: UserType.Club);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'description': description,
      'profilePicture': profilePicture,
      'profileImage1': profileImage1,
      'profileImage2': profileImage2,
      'profileImage3': profileImage3,
      'verified': verified,
      'hostedEventsIds': hostedEventIds
    });
    return map;
  }

  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      description: map['description'],
      profilePicture: map['profilePicture'],
      profileImage1: map['profileImage1'],
      profileImage2: map['profileImage2'],
      profileImage3: map['profileImage3'],
      verified: map['verified'],
      hostedEventIds: List<String>.from(map['hostedEventIds'] ?? []),
    );
  }
}

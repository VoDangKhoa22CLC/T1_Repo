import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookout_dev/data/user_class.dart';

class AccountController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up
  Future<AppUser?> signUp({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? studentId,
    String? major,
    String? clubId,
    String? description,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      print("Signed up user: ${user?.uid}");
      if (user != null) {
        // Create AppUser object
        AppUser appUser;
        if (userType == UserType.Student) {
          appUser = Student(
            uid: user.uid,
            email: email,
            name: name,
            profilePicture: await AppUser.loadDefaultProfilePicture(),
            studentId: studentId!,
            major: major!,
            attendedEventIds: [],
          );
        } else {
          appUser = Club(
            uid: user.uid,
            email: email,
            name: name,
            profilePicture: await AppUser.loadDefaultProfilePicture(),
            description: description!,
            hostedEventIds: [],
          );
        }

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set(appUser.toMap());

        return appUser;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  // Sign In
  Future<AppUser?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Create and return appropriate AppUser object
        if (data['userType'] == UserType.Student.toString()) {
          return Student.fromMap(data);
        } else {
          return Club.fromMap(data);
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  Future<AppUser?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['userType'] == UserType.Student.toString()) {
        return Student.fromMap(data);
      } else {
        return Club.fromMap(data);
      }
    }
    return null;
  }
}

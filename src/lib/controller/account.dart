import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookout_dev/data/user_class.dart';

class AccountController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('users');

  // Sign Up
  Future<(AppUser?, String?)> signUp({
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
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        AppUser appUser;
        if (userType == UserType.Student) {
          appUser = Student(
            uid: user.uid,
            email: email,
            name: name,
            //profilePicture: await AppUser.loadDefaultProfilePicture(),
          );
        } else {
          appUser = Club(
            uid: user.uid,
            email: email,
            name: name,
            //profilePicture: await AppUser.loadDefaultProfilePicture(),
          );
        }
        await _firestore.doc(user.uid).set(appUser.toMap());
        return (appUser, null);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An undefined error happened.';
      }
      return (null, errorMessage);
    } catch (e) {
      return (null, e.toString());
    }
    return (null, 'An unexpected error occurred');
  }

  // Sign In
  Future<(AppUser?, String?)> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore.doc(user.uid).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['userType'] == UserType.Student.toString()) {
          return (Student.fromMap(data), null);
        } else {
          return (Club.fromMap(data), null);
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later.';
          break;
        case 'invalid-credential':
          errorMessage = 'Wrong email or password.';
          break;
        default:
          errorMessage = 'An undefined error happened.';
      }
      print(e);
      return (null, errorMessage);
    } catch (e) {
      print(e.toString());
      return (null, e.toString());
    }
    return (null, 'An unexpected error occurred');
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  Future<AppUser?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.doc(user.uid).get();
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

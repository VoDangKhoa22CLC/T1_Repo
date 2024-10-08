import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class AccountController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');
  final Reference _storage = FirebaseStorage.instance.ref();

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
        await user.sendEmailVerification();

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
              profilePicture: "",
              profileImage1: "",
              profileImage2: "",
              profileImage3: "",
              verified: "false");
        }
        await _userCollection.doc(user.uid).set(appUser.toMap());
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

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
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
        if (!user.emailVerified) {
          signOut();
          return (null, 'Please verify your email');
        }

        DocumentSnapshot doc = await _userCollection.doc(user.uid).get();
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
      return (null, errorMessage);
    } catch (e) {
      return (null, e.toString());
    }
    return (null, 'An unexpected error occurred');
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'The email address is badly formatted.';
        case 'user-not-found':
          return 'No user found for that email.';
        default:
          return 'An error occurred. Please try again.';
      }
    }
  }

  Future<bool> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      return true;
    }
    return false;
  }

  Future<bool> verifyPassword(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        return true;
      }
      print('No user found');
      return false;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeEmail(String newEmail) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(newEmail);
      AppUser? appUser = await getCurrentUser();
      if (appUser != null) {
        appUser.email = newEmail;
        await updateInfo(appUser);
      }
      return true;
    }
    return false;
  }

  Future<void> updateInfo(AppUser user) async {
    await _userCollection.doc(user.uid).set(user.toMap());
  }

  Future<(AppUser?, String?)> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: scopes,
        clientId:
            '38111035694-6qjetlnvp4tt7nskk63p7q8rmrslq65a.apps.googleusercontent.com',
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        return (null, 'Google sign in failed');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Sign in to Firebase with the Google credential
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        DocumentSnapshot doc = await _userCollection.doc(user.uid).get();

        if (!doc.exists) {
          // Create a new user document in Firestore
          await _userCollection.doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'userType': UserType.Student.toString(),
          });
        }

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['userType'] == UserType.Student.toString()) {
          return (Student.fromMap(data), null);
        } else {
          return (Club.fromMap(data), null);
        }
      }
    } catch (e) {
      return (null, 'An error occurred during Google sign in');
    }
    return (null, 'An unexpected error occurred');
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Get the user document
      DocumentSnapshot userDoc = await _userCollection.doc(user.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Check if the user is a club (assuming clubs host events)
      if (userData['userType'] == 'Club') {
        // Get the list of hosted events
        List<String> hostedEventIds =
            List<String>.from(userData['hostedEventIds'] ?? []);

        // Delete each hosted event
        for (String eventId in hostedEventIds) {
          await _eventsCollection.doc(eventId).delete();
        }
      }

      // Delete the user's account
      await user.delete();

      // Delete the user's document from Firestore
      await _userCollection.doc(user.uid).delete();
    }
  }

  // Get current user
  Future<AppUser?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _userCollection.doc(user.uid).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['userType'] == UserType.Student.toString()) {
        return Student.fromMap(data);
      } else {
        return Club.fromMap(data);
      }
    }
    return null;
  }

  Future<List<String>?> get relatedEvents async {
    AppUser? thisUser = await getCurrentUser();
    if (thisUser == null) {
      return [];
    }

    if (thisUser is Student) {
      return thisUser.attendedEventIds;
    } else if (thisUser is Club) {
      return thisUser.hostedEventIds;
    }

    return [];
  }

  Future appendEvents(String eventID) async {
    AppUser? thisUser = await getCurrentUser();
    if (thisUser == null) {
      return [];
    }

    DocumentSnapshot doc = await _userCollection.doc(thisUser.uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<String> evList = [];
    String field = "";

    if (thisUser is Student) {
      field = "attendedEventIds";
      DocumentSnapshot thisEvent = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventID)
          .get();
      Map<String, dynamic> thisEventData =
          thisEvent.data() as Map<String, dynamic>;
      FirebaseFirestore.instance.collection('events').doc(eventID).set(
          {"subscribers": thisEventData["subscribers"] + 1},
          SetOptions(merge: true));
    } else if (thisUser is Club) {
      field = "hostedEventIds";
    }

    if (field != "") {
      List<String> evList = List<String>.from(data[field] as List);
      if (evList.contains(eventID) == false) {
        evList.add(eventID);
        _userCollection
            .doc(thisUser.uid)
            .set({field: evList}, SetOptions(merge: true));
      }
    }
  }

  Future removeEvents(String eventID) async {
    AppUser? thisUser = await getCurrentUser();
    if (thisUser == null) {
      return [];
    }

    DocumentSnapshot doc = await _userCollection.doc(thisUser.uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<String> evList = [];
    String field = "";

    if (thisUser is Student) {
      field = "attendedEventIds";
      DocumentSnapshot thisEvent = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventID)
          .get();
      Map<String, dynamic> thisEventData =
          thisEvent.data() as Map<String, dynamic>;
      FirebaseFirestore.instance.collection('events').doc(eventID).set(
          {"subscribers": thisEventData["subscribers"] - 1},
          SetOptions(merge: true));
    } else if (thisUser is Club) {
      field = "hostedEventIds";
    }

    if (field != "") {
      List<String> evList = List<String>.from(data[field] as List);
      evList.remove(eventID);
      _userCollection
          .doc(thisUser.uid)
          .set({field: evList}, SetOptions(merge: true));
    }
  }

  Future<Club?> getClub({required String clubID}) async {
    DocumentSnapshot eventDoc = await _userCollection.doc(clubID).get();
    Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;

    return Club.fromMap(data);
  }

  final CollectionReference _adminCollection =
      FirebaseFirestore.instance.collection('admins');

  Future<void> setAdminRole(String uid) async {
    await _adminCollection.doc(uid).set({'isAdmin': true});
  }

  Future<bool> isAdmin() async {
    User? user = _auth.currentUser;
    if (user == null) return false;
    DocumentSnapshot doc = await _adminCollection.doc(user.uid).get();
    return doc.exists;
  }

  Future<(AppUser?, String?)> createAdminAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    var (user, error) = await signUp(
      email: email,
      password: password,
      name: name,
      userType: UserType.Club,
    );

    if (user != null) {
      await setAdminRole(user.uid);

      return (user, null);
    }
    return (user, error);
  }

  Future editClubProfile(
      {required String uid,
      required String name,
      required String description}) async {
    await _userCollection.doc(uid).set({
      "description": description,
      "name": name,
    }, SetOptions(merge: true));
  }

  Future editProfileImages(String clubID, int imageIndex, String changes,
      PlatformFile? newImage) async {
    String newImgPath = "";

    if (changes == "delete") {
      newImgPath = "";
    } else if ((changes == "new") & (newImage != null)) {
      newImgPath = "pictures/club/$clubID/${newImage?.name}";
      final refPic = _storage.child(newImgPath);
      refPic.putFile(File(newImage!.path!));
    }

    await _userCollection.doc(clubID).set(
        {'profileImage${imageIndex + 1}': newImgPath}, SetOptions(merge: true));
  }

  Future editProfilePic(String clubID, PlatformFile? newImage) async {
    String newImgPath = "pictures/club/$clubID/${newImage?.name}";
    final refPic = _storage.child(newImgPath);
    refPic.putFile(File(newImage!.path!));

    await _userCollection
        .doc(clubID)
        .set({'profilePicture': newImgPath}, SetOptions(merge: true));
  }

  Future<String> getImageFromUser(String clubID, String terms) async {
    DocumentSnapshot thisClub = await _userCollection.doc(clubID).get();
    Map<String, dynamic> clubData = thisClub.data() as Map<String, dynamic>;

    return clubData[terms];
  }

  Future getListClubs() async {
    final snapshots = FirebaseFirestore.instance.collection('users');
    final stuff = await snapshots.get();
    final accounts = stuff.docs.map((doc) => doc.data());
    List<Club> clubs = accounts.where((acc) => (acc["userType"] == UserType.Club.toString())).map(Club.fromMap).toList();
    return clubs;
  }

  Future verifyClub(String clubID) async {
    await _userCollection.doc(clubID).set({"verified": "true"}, SetOptions(merge: true));
  }

  Future unverifyClub(String clubID) async {
    await _userCollection.doc(clubID).set({"verified": "false"}, SetOptions(merge: true));
  }

}

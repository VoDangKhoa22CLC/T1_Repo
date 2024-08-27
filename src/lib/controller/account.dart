import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookout_dev/data/user_class.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

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

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
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
        DocumentSnapshot doc = await _firestore.doc(user.uid).get();

        if (!doc.exists) {
          // If the user doesn't exist, create a new user in Firestore
          AppUser appUser = Student(
            uid: user.uid,
            email: user.email!,
            name: user.displayName ?? '',
            //profilePicture: await AppUser.loadDefaultProfilePicture(),
          );
          await _firestore.doc(user.uid).set(appUser.toMap());
          return (appUser, null);
        } else {
          // If the user exists, return the existing user data
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['userType'] == UserType.Student.toString()) {
            return (Student.fromMap(data), null);
          } else {
            return (Club.fromMap(data), null);
          }
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
}

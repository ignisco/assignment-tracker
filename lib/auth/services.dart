import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final googleSignIn = GoogleSignIn();

  // User Reference
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Assignments of current user
  static final CollectionReference currentUserAssignmentsCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid)
          .collection("assignments");

  // auth change user stream
  static Stream<User?> get user {
    return auth.userChanges();
  }

  // get userInfo stream
  static Stream<QuerySnapshot> get userAssignments {
    return currentUserAssignmentsCollection
        .orderBy("isFinished")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  static Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await auth.signInWithCredential(credential);
  }

  static Future toggleAssignment(DocumentReference doc, bool value) async {
    doc.set(
      {
        "isFinished": value,
      },
      SetOptions(merge: true),
    );
  }

  static Future addAssignment(String title, DateTime timestamp) async {
    currentUserAssignmentsCollection.doc().set(
      {
        "title": title,
        "timestamp": timestamp,
        "isFinished": false,
      },
    );
  }

  static Future deleteAssignment(DocumentReference doc) async {
    doc.delete();
  }

  // sign out
  static Future signOut() async {
    try {
      return await auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../View/home.dart';
import '../View/login_view.dart';
import '../Model/user_model.dart';
import '../View/profile.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.email);
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((user) => _userFromFirebase(user));
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Check if the user has entered profile data
        final hasEnteredProfileData = await checkProfileData(user.uid);
        if (hasEnteredProfileData) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthExceptions
    } catch (error) {
      // Handle other errors
    }
  }

  Future<bool> checkProfileData(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Information_Form')
          .doc(uid)
          .get();
      final data = snapshot.data();
      // Check if profile data exists
      return data != null;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

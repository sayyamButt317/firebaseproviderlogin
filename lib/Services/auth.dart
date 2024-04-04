import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/user_model.dart';
import '../profile/view/profile.dart';
import '../Home/view/home.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.email);
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((user) => _userFromFirebase(user));
  }

  Future<void> login(BuildContext context) async {
    bool hasEnteredProfiledata = false;
    try {
      final String email = _email.text.trim();
      final String password = _password.text.trim();
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final User? user = _auth.currentUser;
      if (user != null) {
        if (!hasEnteredProfiledata) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile()),
          );
          hasEnteredProfiledata = true;
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'An error occurred while logging in';
      if (error.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Invalid password';
      }

      debugPrint(error.toString());
    }
  }

  Future<void> signup() async {
    await _auth
        .createUserWithEmailAndPassword(
            email: _email.text.toString(), password: _password.text.toString())
        .then((value) {
      // Handle successful sign-up
    }).catchError((error) {
      // Handle sign-up errors
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

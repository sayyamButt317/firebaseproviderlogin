import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/user_model.dart';
import '../profile/view/profile.dart';
import '../Home/view/home.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Dispose text editing controllers to prevent memory leaks
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.email);
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((user) => _userFromFirebase(user));
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = _auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
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
      debugPrint(errorMessage);
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Handle successful sign-up
    } catch (error) {
      // Handle sign-up errors
      debugPrint(error.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

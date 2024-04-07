import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Home/view/home.dart';
import '../Login/view/login_view.dart';
import '../Model/user_model.dart';
import '../profile/view/profile.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool hasEnteredProfiledata = false;
    void updateProfileDataStatus(bool status) {
    hasEnteredProfiledata = status;
    notifyListeners();
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
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
        if (hasEnteredProfiledata) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'An error occurred while logging in';
      if (error.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Invalid password';
      }
      debugPrint(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
Future<void> signup(
  BuildContext context, String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Navigate to your login screen
    );
  } catch (error) {
    debugPrint(error.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

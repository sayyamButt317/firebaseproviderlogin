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
        if (!hasEnteredProfiledata) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
          hasEnteredProfiledata = true;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
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

  Future<void> signup(
      BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reset profile data status flag when a new user signs up
      updateProfileDataStatus(false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (error) {
      debugPrint(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      email = '';
      password = '';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/widget/routes_name.dart';

import '../Model/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isloading = false;
  bool get loading => isloading;

  void setLoading(bool value) {
    isloading = value;
    notifyListeners();
  }

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(user.uid, user.email) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<UserModel?> login(
      BuildContext context, String email, String password) async {
    try {
      setLoading(true);
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      setLoading(false);
      return _userFromFirebaseUser(user);
    } catch (err) {
      setLoading(false);
      if (err is FirebaseAuthException) {
        if (err.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user found'),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (err.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wrong password'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Internal error something went wrong'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('Error: $err');
      }

      return null;
    }
  }
}

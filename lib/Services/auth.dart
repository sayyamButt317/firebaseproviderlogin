import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isloading = false;
  bool get loading => isloading;

  void setLoading(bool value) {
    isloading = value;
    notifyListeners();
  }

//create user object based on firebase user
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null
        ? UserModel(
            user.uid,
            user.email,
          )
        : null;
  }

  //auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future login(BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) {
        User? user = result.user;
        return _userFromFirebaseUser(user);
      }).catchError((err) {
        if (err.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('user-not-found'),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (err.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('wrong-password'),
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
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

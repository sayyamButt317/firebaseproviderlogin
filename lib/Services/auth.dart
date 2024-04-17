import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Model/user_model.dart';
import '../View/home.dart';

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
              content: Text('Internal error something went wrong'),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (err.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Internal error something went wrong'),
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

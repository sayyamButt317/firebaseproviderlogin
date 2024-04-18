import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widget/routes_name.dart';
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

  // Future login(BuildContext context, String email, String password) async {
  //   try {
  //     await _auth
  //         .signInWithEmailAndPassword(email: email, password: password)
  //         .then((result) {
  //       User? user = result.user;
  //       return _userFromFirebaseUser(user);
  //     }).catchError((err) {
  //       if (err.code == 'user-not-found') {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('user-not-found'),
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       } else if (err.code == 'wrong-password') {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('wrong-password'),
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Internal error something went wrong'),
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     return null;
  //   }
  // }

  Future<void> signin(
      BuildContext context, String email, String password) async {
    try {

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('Information_Form')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            Navigator.pushReplacementNamed(context, RouteName.homescreen);
          } else {
            Navigator.pushReplacementNamed(context, RouteName.profilescreen);
          }
        }).catchError((error) {
          print("Error fetching user data: $error");
          Navigator.pushReplacementNamed(context, RouteName.profilescreen);
        });
      } else {
        // If user is not logged in, navigate to login screen
        //snack bar showing the login failure

        //Navigator.pushReplacementNamed(context, RouteName.loginscreen);
      }

    } catch (error) {
      print(error);
    }
    notifyListeners();
  }
}

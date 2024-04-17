import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/routes_name.dart';

class SplashService {
  void checkLogin(BuildContext context) {
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
          Navigator.pushReplacementNamed(context, RouteName.loginscreen);
        }
      }).catchError((error) {
        print("Error fetching user data: $error");
        Navigator.pushReplacementNamed(context, RouteName.loginscreen);
      });
    } else {
      // If user is not logged in, navigate to login screen
      Navigator.pushReplacementNamed(context, RouteName.loginscreen);
    }
  }
}

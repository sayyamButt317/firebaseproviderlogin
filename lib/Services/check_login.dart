import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/widget/routes_name.dart';

class LoginStatus {
  checklogin(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('Information_Form')
          .doc(user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          Navigator.pushNamed(context, RouteName.homescreen);
        } else {
          Navigator.pushNamed(context, RouteName.loginscreen);
        }
      });
    }
  }
}

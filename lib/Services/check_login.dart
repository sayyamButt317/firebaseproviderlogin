import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/View/login_view.dart';
import 'package:login/View/profile.dart';

import 'session_manger.dart';

class LoginStatus {
  dynamic checklogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      SessionController().userId = user.uid.toString();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/routes_name.dart';

class SplashProvider extends ChangeNotifier {
  void checkLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Navigator.pushNamed(context,RouteName.homescreen);
    }
  }
}

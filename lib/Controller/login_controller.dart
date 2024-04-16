import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/session_manger.dart';
import 'package:login/View/home.dart';

import '../widget/routes_name.dart';

class LoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void login(BuildContext context, String email, String password) async {
    setLoading(true);
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        setLoading(false);
        Navigator.pushNamed(context,RouteName.profilescreen);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Created Successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      }).onError((error, stackTrace) {
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while signing up'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } catch (error) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while signing up'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

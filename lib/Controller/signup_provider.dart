import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/routes_name.dart';

class SignupProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signup(BuildContext context, String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Created Successfully'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushNamed(context, RouteName.loginscreen);
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

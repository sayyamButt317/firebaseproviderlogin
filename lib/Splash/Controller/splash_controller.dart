import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  late final bool _isEditing = false;
  bool get isEditing => _isEditing;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void checkLogin() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MyHomePage()),
      // );
    }
  }

  updateData() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // sharedPreferences.setString("email", email.text);
    // sharedPreferences.setString("fullname", name.text);
    // sharedPreferences.setString("password", password.text);
  }

  deleteData() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // sharedPreferences.remove('email');
    // sharedPreferences.remove('fullname');
    // sharedPreferences.remove('password');
    // await sharedPreferences.clear();
    //
    // name.clear();
    // email.clear();
    // password.clear();
  }

  loadData() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // name.text = sharedPreferences.getString('fullname') ?? '';
    // email.text = sharedPreferences.getString('email') ?? '';
    // password.text = sharedPreferences.getString('password') ?? '';
  }
}

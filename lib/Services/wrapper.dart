import 'package:flutter/material.dart';
import 'package:login/Model/user_model.dart';
import 'package:login/View/home.dart';
import 'package:login/View/login_view.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // If the user is authenticated, navigate to the home screen
    if (user != null) {
      return const MyHomePage();
    } else {
      // If the user is not authenticated, navigate to the login screen
      return Login();
    }
  }
}

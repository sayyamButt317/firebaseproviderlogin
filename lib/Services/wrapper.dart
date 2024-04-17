import 'package:flutter/material.dart';
import 'package:login/Model/user_model.dart';
import 'package:login/View/home.dart';
import 'package:login/View/login_view.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return user == null ? Login() : const MyHomePage();
  }
}

import 'package:flutter/material.dart';
import 'package:login/Model/user_model.dart';
import 'package:login/Services/auth.dart';
import 'package:login/View/home.dart';
import 'package:login/View/login_view.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (_, __) => null,
      child: Consumer<UserModel?>(
        builder: (context, user, _) {
          if (user == null) {
            return Login();
          } else {
            return const MyHomePage();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:login/Home/view/home.dart';
import 'package:login/Login/view/login_view.dart';
import 'package:provider/provider.dart';
import '../Model/user_model.dart';
import 'auth.dart';

class LoginStatus extends StatelessWidget {
  const LoginStatus({super.key,});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final UserModel? user = snapshot.data;
            return user == null ? Login() : const MyHomePage();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
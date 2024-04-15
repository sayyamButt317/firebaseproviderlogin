import 'package:flutter/material.dart';
import 'package:login/View/home.dart';
import 'package:login/View/login_view.dart';
import 'package:login/View/profile.dart';
import 'package:login/View/signup.dart';
import 'package:login/View/splash.dart';

import '../widget/routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteName.splashscreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.loginscreen:
        return MaterialPageRoute(builder: (_) => Login());
      case RouteName.signupscreen:
        return MaterialPageRoute(builder: (_) => Signup());
      case RouteName.profilescreen:
        return MaterialPageRoute(builder: (_) => const Profile());
      case RouteName.homescreen:
        return MaterialPageRoute(builder: (_) => const MyHomePage());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
            child: Text("No Route defined for ${settings.name}"),
          ));
        });
    }
  }
}

/* import 'package:flutter/material.dart';
import 'package:login/View/home.dart';
import 'package:login/View/login_view.dart';
import 'package:login/View/profile.dart';
import 'package:login/View/signup.dart';
import 'package:login/View/splash.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = setting.arguments;
    switch(setting.name){
      case RouteName.splashScreen;
      return MaterialPageRoute(builder:(_) => const SplashScreen());
      case RouteName.splashScreen;
      return MaterialPageRoute(builder:(_) =>  Login());
      case RouteName.splashScreen;
      return MaterialPageRoute(builder:(_) =>  Signup());
      case RouteName.splashScreen;
      return MaterialPageRoute(builder:(_) => const Profile());
      case RouteName.splashScreen;
      return MaterialPageRoute(builder:(_) => const MyHomePage());

      default:
      return MaterialPageRoute(builder:(_){
        return Scaffold(
          body:Center(
        child:Text("No Route defined for ${setting.name}"),
        ));
      });
    }
  }
} */

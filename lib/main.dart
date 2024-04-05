import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/auth.dart';
import 'package:login/Services/check_login.dart';
import 'package:login/Splash/Controller/splash_controller.dart';
import 'package:login/profile/Controller/profile_provider.dart';
import 'package:login/profile/view/profile.dart';
import 'package:provider/provider.dart';
import 'Home/Controller/home_provider.dart';
import 'Login/view/login_view.dart';
import 'Signup/view/signup.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginStatus(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/Profile': (context) => Profile(),
      },
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final providercontroller =
        Provider.of<SplashProvider>(context, listen: false);
    Timer(
      const Duration(seconds: 3),
      () {
        providercontroller.checkLogin();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.local_activity),
            ),
          ],
        ),
      ),
    );
  }
}

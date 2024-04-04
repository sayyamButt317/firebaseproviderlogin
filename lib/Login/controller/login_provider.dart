import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  // Future<void> login() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   try {
  //     final String email = _email.text.trim();
  //     final String password = _password.text.trim();
  //     await auth.signInWithEmailAndPassword(email: email, password: password);
  //
  //     final User? user = auth.currentUser;
  //     if (user != null) {
  //       if (!hasEnteredProfiledata) {
  //         Get.offAll(() => const Profile());
  //         hasEnteredProfiledata = true;
  //       }
  //     } else {
  //       Get.offAll(() => const MapPage());
  //     }
  //   } on FirebaseAuthException catch (error) {
  //     String errorMessage = 'An error occurred while logging in';
  //     if (error.code == 'user-not-found') {
  //       errorMessage = 'User not found';
  //     } else if (error.code == 'wrong-password') {
  //       errorMessage = 'Invalid password';
  //     }
  //
  //     debugPrint(error.toString());
  //   }
  // }
}

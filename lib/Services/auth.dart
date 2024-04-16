import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/session_manger.dart';
import 'package:login/View/login_view.dart';

import '../Model/user_model.dart';
import '../widget/routes_name.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.email);
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((user) => _userFromFirebase(user));
  }

  Future<bool> checkProfileData(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Information_Form')
          .doc(uid)
          .get();
      final data = snapshot.data();
      // Check if profile data exists
      return data != null;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void signOut(BuildContext context) async {
    await _auth.signOut().then((value) {
      SessionController().userId = '';
      Navigator.pushNamed(context,RouteName.loginscreen);
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/routes_name.dart';

class SplashService{
  // void checklogin(BuildContext context) {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     FirebaseFirestore.instance
  //         .collection('Information_Form')
  //         .doc(user.uid)
  //         .get()
  //         .then((value) {
  //       if (value.exists) {
  //         Navigator.pushNamed(context, RouteName.profilescreen);
  //       } else {
  //         Navigator.pushNamed(context, RouteName.loginscreen);
  //       }
  //     });
  //   }
  // }


  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth .currentUser;
    if(user!= null){
      Navigator.pushNamed(context, RouteName.profilescreen);
    }
    else {
      Navigator.pushNamed(context, RouteName.loginscreen);
    }
  }


}



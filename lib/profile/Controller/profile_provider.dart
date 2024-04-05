import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileProvider extends ChangeNotifier {
  late bool _isEditing = false;
  bool get isEditing => _isEditing;

  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  final city = <String, String>{
    "name": "Los Angeles",
    "state": "CA",
    "country": "USA"
  };

  // db
  //     .collection("cities")
  //     .doc("LA")
  //     .set(city)
  //     .onError((e, _) => print("Error writing document: $e"));

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  Future<void> storeUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Information_Form')
        .doc(uid)
        .set({
      'firstname': firstname.text,
      'lastname': lastname.text,
      'email': email.text,
    }, SetOptions(merge: true)).onError(
            (e, _) => print("Error writing document: $e"));
  }

  // Future<void> loadData() async {
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //   FirebaseFirestore.instance
  //       .collection('Information_Form')
  //       .doc(uid)
  //       .snapshots()
  //       .listen((event) {
  //     myuser.value = UserModel.fromJson(event.data() ?? {});
  //     firstname.text = myuser.value.firstname ?? '';
  //     lastname.text = myuser.value.lastname ?? '';
  //     email.text = myuser.value.email ?? '';
  //   });
  // }
}

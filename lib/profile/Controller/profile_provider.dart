import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/Info_model.dart';

class ProfileProvider extends ChangeNotifier {
  late bool _isEditing = false;
  bool get isEditing => _isEditing;

  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  Future<void> storeUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
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
  }

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('Information_Form')
          .doc(uid)
          .get();
      final data = snapshot.data();
      if (data != null) {
        myuser.value = InfoModel.fromJson(data);
        firstname.text = myuser.value.firstname ?? '';
        lastname.text = myuser.value.lastname ?? '';
        email.text = myuser.value.email ?? '';
      }
    }
  }

  final myuser = ValueNotifier<InfoModel>(InfoModel(uid: ''));

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
}

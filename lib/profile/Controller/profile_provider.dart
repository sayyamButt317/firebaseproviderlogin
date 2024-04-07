import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../Model/Info_model.dart';

class ProfileProvider extends ChangeNotifier {
  final myuser = ValueNotifier<InfoModel>(InfoModel(uid: ''));

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();

  final FocusNode firstnameFocusNode = FocusNode();
    final FocusNode lastnameFocusNode = FocusNode();
      final FocusNode addressFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  late bool _isEditing = false;
  bool get isEditing => _isEditing;

  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  set selectedImage(XFile? image) {
    if (image != null) {
      _selectedImage = XFile(image.path);
      notifyListeners();
    }
  }

  Future<void> getImage(ImageSource gallery) async {
    final ImagePicker imagepicker = ImagePicker();
    final XFile? image = await imagepicker.pickImage(
      maxWidth: 150,
      maxHeight: 200,
      source: gallery,
    );
    if (image != null) {
      selectedImage = image;
    }
  }

  Future<String> uploadImage(XFile? image) async {
    if (image == null) {
      return '';
    }

    String imageUrl = '';
    try {
      String fileName = Path.basename(image.path);
      var reference =
          FirebaseStorage.instance.ref().child('profileimage/$fileName');
      TaskSnapshot taskSnapshot = await reference.putFile(File(image.path));
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      debugPrint("Download URL: $imageUrl");
    } catch (error) {
      debugPrint("Image Upload Error: $error");
    }
    return imageUrl;
  }

Future<void> storeUserInfo() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final uid = user.uid;
    String imageUrl = await uploadImage(selectedImage);
    await FirebaseFirestore.instance
        .collection('Information_Form')
        .doc(uid)
        .set({
      'firstname': firstname.text,
      'lastname': lastname.text,
      'address': address.text,
      'email': email.text,
      'image': imageUrl, 
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
      address.text = myuser.value.address ?? '';
      email.text = myuser.value.email ?? '';
      String imageUrl = data['image'];
      if (imageUrl.isNotEmpty) {
        selectedImage = XFile(imageUrl);
      }
    }
  }
}


}

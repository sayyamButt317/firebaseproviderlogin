import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login/Model/user_data.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/routes_name.dart';

class ProfileController extends ChangeNotifier {
  ValueNotifier<UserData> myuser = ValueNotifier<UserData>(UserData());

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  final FocusNode firstnameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late bool _isEditing = false;
  bool get isEditing => _isEditing;

  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  File? get image => _selectedImage;

  set selectedImage(File? image) {
    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners();
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(children: [
                ListTile(
                  onTap: () {
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera, color: Colors.black),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image, color: Colors.black),
                  title: const Text('Gallery'),
                ),
              ]),
            ),
          );
        });
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      uploadImage(image!);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      uploadImage(image!);
      notifyListeners();
    }
  }

  Future<String> uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference =
        FirebaseStorage.instance.ref().child('profile_image/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        print("image url :$value");
      },
    );
    notifyListeners();
    return imageUrl;
  }

  Future<void> storeUserInfo(BuildContext context) async {
    String url = await uploadImage(_selectedImage!);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Information_Form').doc(uid).set(
      {
        'firstname': firstnamecontroller.text,
        'lastname': lastnamecontroller.text,
        'address': addresscontroller.text,
        'email': emailcontroller.text,
        'image': url,
      },
      SetOptions(merge: true),
    ).then((value) {
      firstnamecontroller.clear();
      lastnamecontroller.clear();
      addresscontroller.clear();
      emailcontroller.clear();
      setLoading(false);
      Navigator.pushNamed(context, RouteName.homescreen);
    });
  }

  Future<void> loadData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('Information_Form')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myuser.value = UserData.fromJson(event.data()!);
      notifyListeners();
    });
  }
}

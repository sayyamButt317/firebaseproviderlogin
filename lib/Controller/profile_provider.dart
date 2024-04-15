import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/Info_model.dart';
import '../Services/session_manger.dart';
import '../widget/textfeild.dart';

class ProfileController extends ChangeNotifier {
  final myuser = ValueNotifier<InfoModel>(InfoModel(uid: ''));

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');
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

  final picker = ImagePicker();
  XFile? _image;

  XFile? get image => _image;

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
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  void uploadImage(BuildContext context) async {
    setLoading(true);
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('/profileimage${SessionController().userId.toString()}');
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newurl = await storageRef.getDownloadURL();
    ref
        .child(SessionController().userId.toString())
        .update({'image': newurl.toString()}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image updated'),
          duration: Duration(seconds: 3),
        ),
      );
      setLoading(false);
      _image = null;
    }).onError((error, stackTrace) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> showFirstNameDialogueAlert(BuildContext context, String name) {
    firstnamecontroller.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Center(child: Text('Username updated')),
              content: SingleChildScrollView(
                  child: Column(children: [
                CustomTextFormField(
                  focusNode: firstnameFocusNode,
                  controller: firstnamecontroller,
                  prefixIcon: Icons.person,
                  hintText: 'Enter Your First Name',
                  keyboardType: TextInputType.text,
                )
              ])),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      ref.child(SessionController().userId.toString()).update(
                          {'firstnamme': firstnamecontroller.text.toString()});
                      Navigator.pop(context);
                    },
                    child: const Text('okay',
                        style: TextStyle(color: Colors.black)))
              ]);
        });
  }

  /* Future updateinfo(){

        ref.child(SessionController().userId.toString()).update(
            {
              firstnamme': firstnamecontroller.text.toString(),
              'lastnamme': lastnamecontroller.text.toString(),
              'address': addresscontroller.text.toString(),
              'email': emailcontroller.text.toString()},
          ); 
  } */

  /* Future<String> uploadImage(XFile? image) async {
    if (image == null) {
      return '';
    }

    String imageUrl = '';
    try {
      String fileName = Path.basename(image.path);
      var reference = FirebaseStorage.instance
          .ref()
          .child('profileimage/$fileName${SessionController().userId.toString()}');
      TaskSnapshot taskSnapshot = await reference.putFile(File(image.path));
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      debugPrint("Download URL: $imageUrl");
    } catch (error) {
      debugPrint("Image Upload Error: $error");
    }
    return imageUrl;
  } */

  Future storeUserInfo(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      ref.child(SessionController().userId.toString());
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance
          .collection('Information_Form')
          .doc(id)
          .update(
        {
          'firstname': firstnamecontroller.text,
          'lastname': lastnamecontroller.text,
          'address': addresscontroller.text,
          'email': emailcontroller.text,
          'uid': uid,
          'image': _image,
        },
      ).onError((e, _) => print("Error writing document: $e"));
    } catch (error) {
      print('Error saving data: $error');
    }
  }

  Future<void> loadData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    ref.child(SessionController().userId.toString());
    FirebaseFirestore.instance
        .collection('Information_Form')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myuser.value = InfoModel.fromJson(event.data() ?? {});
      selectedImage = (myuser.value.image ?? '') as File?;
      firstnamecontroller.text = myuser.value.firstname ?? '';
      lastnamecontroller.text = myuser.value.lastname ?? '';
      addresscontroller.text = myuser.value.address ?? '';
      emailcontroller.text = myuser.value.email ?? '';
    });
  }
  // Future<void> loadData() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       final uid = user.uid;
  //       final snapshot = await FirebaseFirestore.instance
  //           .collection('Information_Form')
  //           .doc(uid)
  //           .get();
  //       final data = snapshot.data();
  //       if (data != null) {
  //         myuser.value = InfoModel.fromJson(data);
  //         firstname.text = myuser.value.firstname ?? '';
  //         lastname.text = myuser.value.lastname ?? '';
  //         address.text = myuser.value.address ?? '';
  //         email.text = myuser.value.email ?? '';
  //         String imageUrl = data['image'] ?? '';
  //         selectedImage = imageUrl.isNotEmpty ? XFile(imageUrl) : null;
  //       }
  //     }
  //   } catch (error) {
  //     print('Error loading data: $error');
  //   } finally {
  //     firstname.text = '';
  //     lastname.text = '';
  //     address.text = '';
  //     email.text = '';
  //     selectedImage = null;
  //   }
  // }
}

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
import '../widget/routes_name.dart';
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
  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
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

    // Use await to wait for the upload task to complete
    await uploadTask.whenComplete(() async {
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
    }).catchError((error) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }


  Future<void> storeUserInfo(BuildContext context) async {
    // Set loading indicator to true
    setLoading(true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance
          .collection('Information_Form')
          .doc(uid);

      await docRef.set(
        {
          'firstname': firstnamecontroller.text,
          'lastname': lastnamecontroller.text,
          'address': addresscontroller.text,
          'email': emailcontroller.text,
          'uid': uid,
          'image': _image?.path,
        },
      );

      print('User info stored successfully');

      // Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User info saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to the home screen
      Navigator.pushNamed(context, RouteName.homescreen);
    } catch (error) {
      // Print error message
      print('Error saving data: $error');

      // Show a Snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving user info: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      // Set loading indicator back to false
      setLoading(false);
    }
  }


  Future<void> loadData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('Information_Form')
        .doc(uid);

    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data();
        myuser.value = InfoModel.fromJson(data ?? {});

        // Check if the image path is available
        final imagePath = data?['image'] as String?;
        if (imagePath != null && imagePath.isNotEmpty) {
          selectedImage = File(imagePath);
        }

        // Set text controllers
        firstnamecontroller.text = myuser.value.firstname ?? '';
        lastnamecontroller.text = myuser.value.lastname ?? '';
        addresscontroller.text = myuser.value.address ?? '';
        emailcontroller.text = myuser.value.email ?? '';
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error loading data: $error');
    }
  }



}

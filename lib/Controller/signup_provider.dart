import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/session_manger.dart';
import 'package:login/View/home.dart';

class SignupProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signup(BuildContext context, String firstname, String lastname,
      String email, String password) async {
    setLoading(true);
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        ref.child(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'email': value.user!.email.toString(),
          'firstname': firstname,
          'lastname': lastname,
        }).then((value) {
          setLoading(false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        }).onError((error, stackTree) {
          setLoading(false);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Created Successfully'),
            duration: const Duration(seconds: 3),
          ),
        );
      }).onError((error, stackTrace) {
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while signing up'),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    } catch (error) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while signing up'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

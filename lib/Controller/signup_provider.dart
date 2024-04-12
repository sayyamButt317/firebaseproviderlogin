import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupProvider extends ChangeNotifier {

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signup(
      String firstname, String lastname, String email, String password) async {
    setLoading(true);
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
                 ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Created Successfully'),
          duration: Duration(seconds: 3),
        ),
        setLoading(false);
      );
          })
          .onError((error, stackTrace) {
            setLoading(false);
                 ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while signing up'),
          duration: Duration(seconds: 3),
        ),
      );
          });
    }catch (error) {
      setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while signing up'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}


         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while signing up'),
          duration: Duration(seconds: 3),
        ),
      );
          Fluttertoast.showToast(
        msg: "This is a Toast message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
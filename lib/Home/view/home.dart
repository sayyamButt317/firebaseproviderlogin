import 'dart:math';

import 'package:flutter/material.dart';
import 'package:login/Login/view/login_view.dart';
import 'package:provider/provider.dart';
import '../../Services/auth.dart';
import '../../profile/Controller/profile_provider.dart';
import '../../widget/textfeild.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final providerController = Provider.of<ProfileProvider>(context, listen: false);
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        leading: IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmation'),
                  content: const Text('Do you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        auth.signOut();
                        Navigator.push(context,MaterialPageRoute(builder: ((context) => Login())));
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.lock),
        ),
        title: const Text(
          'Home',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: providerController.firstname,
                      prefixIcon: Icons.person,
                      readOnly: true,
                      textColor: Colors.grey,
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: providerController.lastname,
                      prefixIcon: Icons.person,
                      readOnly: true,
                      textColor: Colors.grey,
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: providerController.email,
                      hintText: '',
                      readOnly: true,
                      textColor: Colors.grey,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     AppButton(
              //       text: ("Sign Up"),
              //       width: MediaQuery.sizeOf(context).width * 0.89,
              //       onPressed: () async {
              //         if (_formKey.currentState!.validate()) {
              //           final SharedPreferences sharedPreferences =
              //               await SharedPreferences.getInstance();
              //           sharedPreferences.setString(
              //               'fullname', providerController.name.text);
              //           sharedPreferences.setString(
              //               'email', providerController.email.text);
              //           sharedPreferences.setString(
              //               'password', providerController.password.text);
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => MyHomePage()),
              //           );
              //         }
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

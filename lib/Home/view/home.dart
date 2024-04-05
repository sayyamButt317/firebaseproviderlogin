import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Widget/btn.dart';
import '../../../Widget/textfeild.dart';
import '../../Splash/Controller/splash_controller.dart';
import '../Controller/home_provider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final providerController =
        Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
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
                      controller: providerController.name,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Name!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: providerController.name,
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Name!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: providerController.email,
                      prefixIcon: Icons.alternate_email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Email!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      hintText: '',
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: providerController.password,
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Email!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      hintText: '',
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

import 'package:flutter/material.dart';
import 'package:login/Controller/signup_provider.dart';
import 'package:login/widget/btn.dart';
import 'package:login/widget/textfeild.dart';
import 'package:provider/provider.dart';

import '../widget/routes_name.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: const Text(
          'Register',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ChangeNotifierProvider(
            create: (_) => SignupProvider(),
            child:
                Consumer<SignupProvider>(builder: (context, provider, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          CustomTextFormField(
                            controller: emailController,
                            prefixIcon: Icons.alternate_email,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your Email'
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter Your Email',
                          ),
                          const SizedBox(height: 15),
                          CustomTextFormField(
                            controller: passwordController,
                            prefixIcon: Icons.lock,
                            obscureText: true,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your password'
                                : null,
                            keyboardType: TextInputType.text,
                            hintText: 'Enter Your Password',
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Center(
                          child: AppButton(
                            text: ("Sign Up"),
                            loading: provider.loading,
                            width: MediaQuery.sizeOf(context).width * 0.87,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                provider.signup(
                                  context,
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an Account ?"),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RouteName.loginscreen);
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}

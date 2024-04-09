import 'package:flutter/material.dart';
import 'package:login/Services/auth.dart';
import 'package:login/Signup/Controller/signup_provider.dart';
import 'package:provider/provider.dart';
import '../../Login/view/login_view.dart';
import '../../widget/btn.dart';
import '../../widget/textfeild.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final providerController = Provider.of<SignupProvider>(context);
    final authService = Provider.of<AuthService>(context);
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
                      controller: providerController.emailController,
                      prefixIcon: Icons.alternate_email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Email!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter Your Email',
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: providerController.passwordController,
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (String? password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        }

                        if (password.length < 6) {
                          return 'Your password is too short';
                        } else if (password.length < 8) {
                          return 'Your password is acceptable but not strong';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Your Password',
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              Row(
                children: [
                  AppButton(
                    text: ("Sign Up"),
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email =
                            providerController.emailController.text.trim();
                        String password =
                            providerController.passwordController.text.trim();
                        await authService.signup(context, email, password);
                      }
                    },
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:login/Services/auth.dart';
import 'package:provider/provider.dart';
import '../../../Widget/btn.dart';
import '../../../Widget/textfeild.dart';
import '../../Login/view/login_view.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
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
                      controller: emailController,
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
                      controller: passwordController,
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
                    width: MediaQuery.sizeOf(context).width * 0.89,
                    onPressed: ()async {
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        await authservice.signup(email, password);
                        Navigator.pop(context);
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

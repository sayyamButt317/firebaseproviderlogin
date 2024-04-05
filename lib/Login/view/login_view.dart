import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/Home/view/home.dart';
import 'package:login/Signup/view/signup.dart';
import 'package:provider/provider.dart';
import '../../../Widget/btn.dart';
import '../../../Widget/textfeild.dart';
import '../../Services/auth.dart';
import '../../profile/view/profile.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: const Text(
          'Login',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
                    hintText: 'Enter  your Email',
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

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    hintText: 'Enter  your Password',
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              Row(
                children: [
                  AppButton(
                    text: ("Login"),
                    width: MediaQuery.sizeOf(context).width * 0.89,
                    onPressed: () async {
                      await authservice.login(context, emailController.text,
                          passwordController.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Create an Account ?"),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: const Text(
                      " Signup",
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

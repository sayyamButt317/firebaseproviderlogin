import 'package:flutter/material.dart';
import 'package:login/Services/auth.dart';
import 'package:provider/provider.dart';
import '../widget/btn.dart';
import '../widget/routes_name.dart';
import '../widget/textfeild.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      prefixIcon: Icons.alternate_email,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your Email' : null,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter your Email',
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: passwordController,
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your password' : null,
                      keyboardType: TextInputType.text,
                      hintText: 'Enter your Password',
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                Row(
                  children: [
                    Consumer<AuthService>(
                      builder: (context, provider, child) {
                        return Center(
                          child: AppButton(
                            text: ("Login"),
                            loading: provider.loading,
                            width: MediaQuery.of(context).size.width * 0.87,
                            onPressed: () async {
                              var form = _formKey.currentState;
                              if (form!.validate()) {
                                provider.setLoading(
                                    true); // Set loading to true before login
                                String email = emailController.text.trim();
                                String password =
                                    passwordController.text.trim();

                                try {
                                  await provider
                                      .login(context, email, password)
                                      .then((result) {
                                    if (result != null) {
                                      provider.setLoading(
                                          false); // Set loading to false after successful login
                                    } else {
                                      provider.setLoading(
                                          false); // Set loading to false if login fails
                                    }
                                  });
                                } catch (error) {
                                  print('Error: $error');
                                  provider.setLoading(
                                      false); // Set loading to false in case of error
                                }
                              }
                            },
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
                        Navigator.pushNamed(context, RouteName.signupscreen);
                      },
                      child: const Text(
                        " Signup",
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
          ),
        ),
      ),
    );
  }
}

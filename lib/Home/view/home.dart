import 'package:flutter/material.dart';
import 'package:login/Services/auth.dart';
import 'package:provider/provider.dart';
import '../../../Widget/btn.dart';
import '../../../Widget/textfeild.dart';
import '../../Signup/view/signup.dart';
import '../../Splash/Controller/splash_controller.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  }) {
    // context.read<SplashProvider>().loadData();
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  late bool isEditing = false;
  final FocusNode nameFocusNode = FocusNode();

  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final providerController = Provider.of<SplashProvider>(context);
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer(
                  builder: ((context, value, child) => CustomTextFormField(
                        focusNode: nameFocusNode,
                        controller: providerController.name,
                        prefixIcon: Icons.alternate_email,
                        hintText: 'Enter Your Name',
                        readOnly: !isEditing,
                        enabled: isEditing,
                        textColor: isEditing ? Colors.black : Colors.grey,
                      ))),
              const SizedBox(height: 15),
              Consumer(
                  builder: ((context, value, child) => CustomTextFormField(
                        focusNode: emailFocusNode,
                        controller: providerController.email,
                        prefixIcon: Icons.alternate_email,
                        hintText: 'Enter Your Email',
                        readOnly: !isEditing,
                        enabled: isEditing,
                        textColor: isEditing ? Colors.black : Colors.grey,
                      ))),
              const SizedBox(height: 15),
              Consumer(
                  builder: ((context, value, child) => CustomTextFormField(
                        controller: providerController.password,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        hintText: 'Enter Your Password',
                        readOnly: !isEditing,
                        enabled: isEditing,
                        textColor: isEditing ? Colors.black : Colors.grey,
                      ))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!isEditing)
                    AppButton(
                      width: MediaQuery.of(context).size.width * 0.9,
                      text: 'Edit',
                      onPressed: () async {
                        isEditing = true;
                        nameFocusNode.requestFocus();
                      },
                    ),
                  if (isEditing)
                    AppButton(
                      width: MediaQuery.of(context).size.width * 0.9,
                      text: 'Save',
                      onPressed: () async {
                        // isEditing = false;
                        // providerController.updateData();
                      },
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

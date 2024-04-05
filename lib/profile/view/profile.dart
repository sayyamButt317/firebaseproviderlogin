import 'package:flutter/material.dart';
import 'package:login/Services/auth.dart';
import 'package:provider/provider.dart';
import '../../../Widget/btn.dart';
import '../../../Widget/textfeild.dart';
import '../Controller/profile_provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileProvider providerController;

  @override
  void initState() {
    super.initState();
    providerController = Provider.of<ProfileProvider>(context, listen: false);
    // providerController.loadData();
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
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
              Consumer<ProfileProvider>(
                builder: (context, value, child) => CustomTextFormField(
                  focusNode: value.nameFocusNode,
                  controller: value.firstname,
                  prefixIcon: Icons.person,
                  hintText: 'Enter Your First Name',
                  readOnly: !value.isEditing,
                  enabled: value.isEditing,
                  textColor: value.isEditing ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Consumer<ProfileProvider>(
                builder: (context, value, child) => CustomTextFormField(
                  focusNode: value.emailFocusNode,
                  controller: value.lastname,
                  prefixIcon: Icons.person_2_outlined,
                  hintText: 'Enter Your Last Name',
                  readOnly: !value.isEditing,
                  enabled: value.isEditing,
                  textColor: value.isEditing ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Consumer<ProfileProvider>(
                builder: (context, value, child) => CustomTextFormField(
                  controller: value.email,
                  prefixIcon: Icons.alternate_email,
                  hintText: 'Enter Your Email',
                  readOnly: !value.isEditing,
                  enabled: value.isEditing,
                  textColor: value.isEditing ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!providerController.isEditing)
                    AppButton(
                      width: MediaQuery.of(context).size.width * 0.9,
                      text: 'Edit',
                      onPressed: () async {
                        providerController.isEditing = true;
                        providerController.nameFocusNode.requestFocus();
                      },
                    ),
                  if (providerController.isEditing)
                    AppButton(
                      width: MediaQuery.of(context).size.width * 0.9,
                      text: 'Save',
                      onPressed: () async {
                        providerController.isEditing = false;
                        providerController.storeUserInfo();
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

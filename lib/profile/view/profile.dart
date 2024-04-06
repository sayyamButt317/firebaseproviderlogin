import 'package:flutter/material.dart';
import 'package:login/Home/view/home.dart';
import 'package:login/Services/auth.dart';
import 'package:provider/provider.dart';
import '../../../Widget/btn.dart';
import '../../../Widget/textfeild.dart';
import '../Controller/profile_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileProvider providerController;

  @override
  void initState() {
    super.initState();
    providerController = Provider.of<ProfileProvider>(context, listen: false);
    providerController.loadData();
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
                builder: (context, value, child) => SizedBox(
          width: 300,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Center(),
          SizedBox(
            height:  MediaQuery.sizeOf(context).height* 0.2,
               child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        providerController.getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? (myuser.value.image != null &&
                          myuser.value.image!.isNotEmpty)
                          ? Container(
                        width: 120,
                        height: 120,
                        margin:
                        const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 5,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                myuser.value.image!
                            ),
                          ),
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : Container(
                        width: 120,
                        height: 120,
                        margin:
                        const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],

            ),
              ),

              Consumer<ProfileProvider>(
                builder: (context, value, child) => CustomTextFormField(
                  focusNode: value.nameFocusNode,
                  controller: value.firstname,
                  prefixIcon: Icons.person,
                  hintText: 'Enter Your Full Name',
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
                  hintText: 'Enter Your Address',
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
                        await providerController.storeUserInfo();
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

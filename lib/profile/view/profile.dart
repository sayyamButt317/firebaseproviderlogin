import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/Home/view/home.dart';
import 'package:login/Services/auth.dart';
import 'package:provider/provider.dart';
import '../../widget/btn.dart';
import '../../widget/textfeild.dart';
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

  void getImage(ImageSource source) async {
    providerController.getImage(source);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FutureBuilder(
              future: providerController.loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
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
                              GestureDetector(
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                },
                                child: value.selectedImage == null
                                    ? (value.myuser.value.image != null &&
                                            value.myuser.value.image!.isNotEmpty
                                        ? Container(
                                            width: 120,
                                            height: 120,
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 5,
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    value.myuser.value.image!),
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
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
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
                                          ))
                                    : Container(
                                        width: 120,
                                        height: 120,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                value.selectedImage!.path),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.08),
                              CustomTextFormField(
                                focusNode: value.firstnameFocusNode,
                                controller: value.firstname,
                                prefixIcon: Icons.person,
                                hintText: 'Enter Your First Name',
                                readOnly: !value.isEditing,
                                enabled: value.isEditing,
                                textColor: value.isEditing
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 15),
                              CustomTextFormField(
                                focusNode: value.lastnameFocusNode,
                                controller: value.lastname,
                                prefixIcon: Icons.person,
                                hintText: 'Enter Your last Name',
                                readOnly: !value.isEditing,
                                enabled: value.isEditing,
                                textColor: value.isEditing
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 15),
                              CustomTextFormField(
                                focusNode: value.addressFocusNode,
                                controller: value.address,
                                prefixIcon: Icons.person_2_outlined,
                                hintText: 'Enter Your Address',
                                readOnly: !value.isEditing,
                                enabled: value.isEditing,
                                textColor: value.isEditing
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 15),
                              CustomTextFormField(
                                controller: value.email,
                                prefixIcon: Icons.alternate_email,
                                hintText: 'Enter Your Email',
                                readOnly: !value.isEditing,
                                enabled: value.isEditing,
                                textColor: value.isEditing
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (!value.isEditing)
                                    AppButton(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      text: 'Edit',
                                      onPressed: () async {
                                        value.isEditing = true;
                                        value.firstnameFocusNode.requestFocus();
                                      },
                                    ),
                                  if (value.isEditing)
                                    AppButton(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      text: 'Save',
                                      onPressed: () async {
                                        value.isEditing = false;
                                        await value.storeUserInfo();
                                        authService
                                            .updateProfileDataStatus(true);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

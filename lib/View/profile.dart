import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/session_manger.dart';
import 'package:provider/provider.dart';
import '../Controller/profile_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: StreamBuilder(
                  stream:
                      ref.child(SessionController().userId.toString()).onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Consumer<ProfileController>(
                            builder: (context, value, child) => SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Center(
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: provider.image == null
                                                    ? map['image'].toString() ==
                                                            ""
                                                        ? const Icon(Icons
                                                            .person_outline)
                                                        : Image(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                value.image!
                                                                    .path),
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            },
                                                            errorBuilder:
                                                                (context,
                                                                    object,
                                                                    stck) {
                                                              return const Icon(
                                                                Icons
                                                                    .error_outline,
                                                                color:
                                                                    Colors.red,
                                                              );
                                                            })
                                                    : Stack(
                                                        children: [
                                                          Image.file(File(
                                                                  provider
                                                                      .image!
                                                                      .path)
                                                              .absolute),
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ],
                                                      )),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          provider.pickImage(context);
                                        },
                                        child: const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.black,
                                          child: Icon(Icons.add,
                                              color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08),
                                  ReusableRow(
                                      title: 'FirstName',
                                      value: map['firstname'],
                                      iconData: Icons.person_outline),
                                  ReusableRow(
                                      title: 'LirstName',
                                      value: map['lastname'],
                                      iconData: Icons.person_outline),
                                  ReusableRow(
                                      title: 'Email',
                                      value: map['email'],
                                      iconData: Icons.email_outlined),
                                  /* CustomTextFormField(
                                    value: map['firstname'],
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
                                    value: map['lastname'],
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
                                  ), */
                                  const SizedBox(height: 20),
                                  /* Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (!value.isEditing)
                                        AppButton(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          text: 'Edit',
                                          onPressed: () async {
                                            value.isEditing = true;
                                            value.firstnameFocusNode
                                                .requestFocus();
                                          },
                                        ),
                                      if (value.isEditing)
                                        AppButton(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          text: 'Save',
                                          onPressed: () async {
                                            value.isEditing = false;
                                            await value.storeUserInfo();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyHomePage()),
                                            );
                                          },
                                        ),
                                    ],
                                  ), */
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text(
                        'Something went wrong',
                      ));
                    }
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const ReusableRow(
      {Key? key,
      required this.title,
      required this.value,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text(title), trailing: Text(value), leading: Icon(iconData)),
        Divider(
          color: Colors.grey.withOpacity(0.5),
        ),
      ],
    );
  }
}

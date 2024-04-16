import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/session_manger.dart';
import 'package:provider/provider.dart';
import '../Controller/profile_provider.dart';
import '../widget/btn.dart';
import '../widget/routes_name.dart';
import '../widget/textfeild.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ref = FirebaseFirestore.instance.collection('Information_Form');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ProfileController>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  stream: ref
                      .doc(SessionController().userId.toString())
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data == null ||
                        !snapshot.data!.exists) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('No data available'),
                        ],
                      );
                    } else {
                      Map<String, dynamic> map = snapshot.data!.data()!;
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
                                                  ? const Icon(
                                                  Icons.person_outline)
                                                  : Image(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    map['image']
                                                        .toString()),
                                                loadingBuilder: (context,
                                                    child,
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
                                                    (context, object,
                                                    stck) {
                                                  return const Icon(
                                                    Icons
                                                        .error_outline,
                                                    color: Colors.red,
                                                  );
                                                },
                                              )
                                                  : Stack(
                                                children: [
                                                  Image.file(File(provider
                                                      .image!.path)
                                                      .absolute),
                                                  const Center(
                                                      child:
                                                      CircularProgressIndicator()),
                                                ],
                                              ),
                                            ),
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
                                  const SizedBox(height: 20),
                                  CustomTextFormField(
                                    value: map['firstname'],
                                    focusNode: value.firstnameFocusNode,
                                    controller: value.firstnamecontroller,
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
                                    controller: value.lastnamecontroller,
                                    prefixIcon: Icons.person_outline,
                                    hintText: 'Enter Your Last Name',
                                    readOnly: !value.isEditing,
                                    enabled: value.isEditing,
                                    textColor: value.isEditing
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextFormField(
                                    focusNode: value.addressFocusNode,
                                    controller: value.addresscontroller,
                                    prefixIcon: Icons.home,
                                    hintText: 'Enter Your Address',
                                    readOnly: !value.isEditing,
                                    enabled: value.isEditing,
                                    textColor: value.isEditing
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextFormField(
                                    controller: value.emailcontroller,
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
                                            await value.storeUserInfo(context);
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
          );
        }),
      ),
    );
  }
}


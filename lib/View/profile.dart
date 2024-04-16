import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/profile_provider.dart';
import '../widget/btn.dart';
import '../widget/textfeild.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Information_Form');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProfileController>(context, listen: false).loadData();
    });
  }

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
                child: StreamBuilder<DocumentSnapshot>(
                    stream: usersCollection.doc(user!.uid).snapshots(),
                    builder: (ctx, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      }
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
                                                  ? const Icon(
                                                      Icons.person_outline)
                                                  : Image(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        streamSnapshot
                                                            .data!['image'],
                                                      ),
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                      errorBuilder: (context,
                                                          object, stck) {
                                                        return const Icon(
                                                          Icons.error_outline,
                                                          color: Colors.red,
                                                        );
                                                      },
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
                                    value: value.myuser.value.firstname,
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
                                    value: value.myuser.value.lastname,
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
                                    value: value.myuser.value.address,
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
                                    value: value.myuser.value.email,
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
                    }),
              ),
            ),
          );
        }),
      ),
    );
  }
}

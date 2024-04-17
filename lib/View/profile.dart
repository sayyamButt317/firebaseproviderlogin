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
    Provider.of<ProfileController>(context, listen: false).loadData();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(builder: (context, provider, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: provider.image == null
                                            ? const Icon(Icons.person_outline)
                                            : Image.file(
                                                provider.image!,
                                                fit: BoxFit.cover,
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
                              focusNode: provider.firstnameFocusNode,
                              controller: provider.firstnamecontroller,
                              prefixIcon: Icons.person,
                              hintText: 'Enter Your First Name',
                              readOnly: !provider.isEditing,
                              enabled: provider.isEditing,
                              textColor: provider.isEditing
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              focusNode: provider.lastnameFocusNode,
                              controller: provider.lastnamecontroller,
                              prefixIcon: Icons.person_outline,
                              hintText: 'Enter Your Last Name',
                              readOnly: !provider.isEditing,
                              enabled: provider.isEditing,
                              textColor: provider.isEditing
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              focusNode: provider.addressFocusNode,
                              controller: provider.addresscontroller,
                              prefixIcon: Icons.home,
                              onChanged: (value) => value.changeaddress(value),
                              hintText: 'Enter Your Address',
                              readOnly: !provider.isEditing,
                              enabled: provider.isEditing,
                              textColor: provider.isEditing
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              controller: provider.emailcontroller,
                              prefixIcon: Icons.alternate_email,
                              onChanged: (value) => value.changeemail(value),
                              hintText: 'Enter Your Email',
                              readOnly: !provider.isEditing,
                              enabled: provider.isEditing,
                              textColor: provider.isEditing
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (!provider.isEditing)
                                  AppButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    text: 'Edit',
                                    onPressed: () async {
                                      provider.isEditing = true;
                                      provider.firstnameFocusNode
                                          .requestFocus();
                                    },
                                  ),
                                if (provider.isEditing)
                                  AppButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    text: 'Save',
                                    onPressed: () async {
                                      provider.isEditing = false;
                                      await provider.storeUserInfo(context);
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

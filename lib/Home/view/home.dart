import 'package:flutter/material.dart';
import 'package:login/Login/view/login_view.dart';
import 'package:provider/provider.dart';
import '../../Services/auth.dart';
import '../../profile/Controller/profile_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    final profileProvider = Provider.of<ProfileProvider>(context); // Add this line

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        automaticallyImplyLeading: true,
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
                        Navigator.push(
                            context, MaterialPageRoute(builder: ((context) => Login())));
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
        title: const Text(
          'Home',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey),
                    const SizedBox(width: 10),
                    Consumer<ProfileProvider>(
                      builder: (context, value, child) => Text(
                        profileProvider.myuser.value.firstname ?? '', 
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.home, color: Colors.grey),
                    const SizedBox(width: 10),
                    Consumer<ProfileProvider>(
                      builder: (context, value, child) => Text(
                        profileProvider.myuser.value.address ?? '', 
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.grey),
                    const SizedBox(width: 10),
                    Consumer<ProfileProvider>(
                      builder: (context, value, child) => Text(
                        profileProvider.myuser.value.email ?? '',
                        style: const TextStyle(color: Colors.grey),
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

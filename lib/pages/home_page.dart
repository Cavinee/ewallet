import 'package:ewallet/keys/navigator_key.dart';
import 'package:ewallet/models/user_provider.dart';
import 'package:ewallet/widgets/total_balance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserData = userProvider.userData;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            (currentUserData != null
                ? currentUserData["userName"].toString()
                : "Loading..."),
          ),
          actions: [
            Hero(
              tag: 'profile_icon',
              child: IconButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'), 
                icon: const Icon(Icons.person_2_outlined)
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const TotalBalance(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal
                ),
                onPressed: () async {
                  await userProvider.signOut(context: context);
                  navigatorKey.currentState?.popAndPushNamed('/');
                },
                child: const Text("Log Out", style: TextStyle(color: Colors.white)))
          ],
        )));
  }
}

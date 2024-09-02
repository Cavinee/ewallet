import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/keys/navigator_key.dart';
import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalBalance extends StatefulWidget {
  const TotalBalance({super.key});

  @override
  State<TotalBalance> createState() => _TotalBalanceState();
}

class _TotalBalanceState extends State<TotalBalance> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.fetchUserData();
    final currentUserData = userProvider.userData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 25.0),
      width: 2000,
      child: Column(
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
              child: Column(
                children: [
                  const Text("Total balance:"),
                  Text(
                    (currentUserData != null
                        ? '\$${userProvider.userData?["balance"]}'
                        : "Loading..."),
                    style: const TextStyle(fontSize: 30),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 40),
                                  backgroundColor: Colors.teal
                                ),
                                onPressed: () => topUpDialog(context),
                                child: const Text("Top up", style: TextStyle(color: Colors.white))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 40),
                                  backgroundColor: Colors.teal
                                ),
                                onPressed: () => payDialog(context),
                                child: const Text("Pay", style: TextStyle(color: Colors.white))),
                          )
                        ],
                      ))
                ],
              )),
        ],
      ),
    );
  }
}

Future<void> topUpDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final topUpController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user;
  // userProvider.fetchUserData();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Top Up"),
          content: Form(
              key: formKey,
              child: TextFormField(
                  controller: topUpController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    } else if (int.parse(value) < 0) {
                      return "Please enter a positive value";
                    }
                    return null;
                  })),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(340,40),
                  backgroundColor: Colors.teal
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    userProvider.userData?["balance"] +=
                        int.parse(topUpController.text);
                    await db.collection("users").doc(user?.uid).update({
                      "balance": userProvider.userData?["balance"]
                    });
                    navigatorKey.currentState!.pop();
                  }
                },
                child: const Text("Top Up", style: TextStyle(color: Colors.white)))
          ],
        );
      });
}

Future<void> payDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final topUpController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user;
  // userProvider.fetchUserData();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pay"),
          content: Form(
              key: formKey,
              child: TextFormField(
                  controller: topUpController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    } else if (int.parse(value) < 0) {
                      return "Please enter a positive value";
                    } else if (userProvider.userData?["balance"] <
                        int.parse(topUpController.text)) {
                      return "Insufficient balance";
                    }
                    return null;
                  })),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(340,40),
                  backgroundColor: Colors.teal
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    userProvider.userData?["balance"] -=
                        int.parse(topUpController.text);
                    await db.collection("users").doc(user?.uid).update({
                      "balance": userProvider.userData?["balance"]
                    });
                    navigatorKey.currentState!.pop();
                  }
                },
                child: const Text("Pay", style: TextStyle(color: Colors.white)))
          ],
        );
      });
}

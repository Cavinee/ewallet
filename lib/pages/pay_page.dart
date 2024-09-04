import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/keys/navigator_key.dart';
import 'package:ewallet/keys/snackbar_key.dart';
import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodeBalance = FocusNode();

  @override
  void initState() {
    focusNodeUserName.addListener(() {
      setState(() {});
    });

    focusNodeBalance.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.fetchUserData();

    final user = userProvider.user;

    final db = FirebaseFirestore.instance;

    return Scaffold(
        appBar: AppBar(title: const Text("Pay")),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 100.0),
                margin: const EdgeInsets.all(0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            focusNode: focusNodeUserName,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person,
                                  color: focusNodeUserName.hasFocus
                                      ? Colors.teal
                                      : Colors.grey),
                              labelText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            enabled: true,
                            controller: userNameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username cannot be empty";
                              } else if (userNameController.text ==
                                  userProvider.userData?["userName"]) {
                                return "You cannot pay to yourself";
                              }

                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              focusNode: focusNodeBalance,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.money,
                                    color: focusNodeBalance.hasFocus
                                        ? Colors.teal
                                        : Colors.grey),
                                labelText: "Balance",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              controller: balanceController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a value";
                                } else if (int.parse(value) < 0) {
                                  return "Please enter a positive value";
                                } else if (userProvider.userData?["balance"] <
                                    int.parse(balanceController.text)) {
                                  return "Insufficient balance";
                                }
                                return null;
                              }),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(340, 40),
                                backgroundColor: Colors.teal),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (formKey.currentState!.validate()) {
                                  final uniqueUsername = db
                                      .collection('users')
                                      .where('userName',
                                          isEqualTo:
                                              userNameController.text.trim());
                                  final snapshot = await uniqueUsername.get();

                                  if (snapshot.docs.isEmpty) {
                                    const errSnackBar = SnackBar(
                                        content: Text("User does not exist."),
                                        duration: Duration(seconds: 5));
                                    snackbarKey.currentState
                                        ?.showSnackBar(errSnackBar);
                                    return;
                                  } else {
                                    DocumentSnapshot targetUser = await db
                                        .collection('users')
                                        .where('userName',
                                            isEqualTo:
                                                userNameController.text.trim())
                                        .get()
                                        .then((targetUser) =>
                                            targetUser.docs.first);

                                    Map<String, dynamic> targetUserData =
                                        targetUser.data()
                                            as Map<String, dynamic>;

                                    targetUserData["balance"] +=
                                        int.parse(balanceController.text);
                                    userProvider.userData?["balance"] -=
                                        int.parse(balanceController.text);

                                    await db
                                        .collection("users")
                                        .doc(targetUserData["uid"])
                                        .update({
                                      "balance": targetUserData["balance"]
                                    });

                                    await db
                                        .collection("users")
                                        .doc(user?.uid)
                                        .update({
                                      "balance":
                                          userProvider.userData?["balance"]
                                    });
                                    navigatorKey.currentState!.pop();
                                  }
                                }
                              }
                            },
                            child: const Text("Pay",
                                style: TextStyle(color: Colors.white)))
                      ],
                    )))));
  }
}

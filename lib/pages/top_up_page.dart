import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/keys/navigator_key.dart';
import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final topUpController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user;
  // userProvider.fetchUserData();

  return Scaffold(
          appBar: AppBar(
            title: const Text("Top Up"),
          ),
          body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 250.0),
                  margin: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.money,
                                color: focusNode.hasFocus ? Colors.teal : Colors.grey),
                            labelText: "Amount",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                            controller: topUpController,
                            keyboardType: const TextInputType.numberWithOptions(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a value";
                              } else if (int.parse(value) < 0) {
                                return "Please enter a positive value";
                              }
                              return null;
                            }),
                      ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(340, 40),
                                  backgroundColor: Colors.teal),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  userProvider.userData?["balance"] +=
                                      int.parse(topUpController.text);
                                  await db
                                      .collection("users")
                                      .doc(user?.uid)
                                      .update({"balance": userProvider.userData?["balance"]});
                                  navigatorKey.currentState!.pop();
                                }
                              },
                              child:
                                  const Text("Top Up", style: TextStyle(color: Colors.white))),
                          )
                            ],
                  ),
                )),
          ),
            
        );
      }
}
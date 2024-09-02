import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/keys/navigator_key.dart';
import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodePhoneNumber = FocusNode();

  @override
  void initState() {
    focusNodeUserName.addListener(() {
      setState(() {});
    });

    focusNodePhoneNumber.addListener(() {
      setState(() {});
    });
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData().then((_) {
      final userData = userProvider.userData;
      userNameController.text = userData?["userName"];
      phoneNumberController.text = userData?["phoneNumber"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.fetchUserData();

    final user = userProvider.user;

    final db = FirebaseFirestore.instance;

    return Scaffold(
        appBar: AppBar(title: const Text("Edit Profile")),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 100.0),
                margin: const EdgeInsets.all(0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Hero(
                          tag: 'profile_icon',
                          child: Icon(Icons.person_2_outlined, size: 100),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            focusNode: focusNodeUserName,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person,
                                  color: focusNodeUserName.hasFocus ? Colors.teal : Colors.grey),
                              labelText: "Full Name",
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
                              }
                          
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            focusNode: focusNodePhoneNumber,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone,
                                  color: focusNodePhoneNumber.hasFocus ? Colors.teal : Colors.grey),
                              labelText: "Phone Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                              controller: phoneNumberController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Phone number cannot be empty";
                                }
                          
                                return null;
                              }),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {

                                await db
                                    .collection("users")
                                    .doc(user?.uid)
                                    .update({
                                  "userName": userNameController.text.trim(),
                                  "phoneNumber":
                                      phoneNumberController.text.trim()
                                });

                                navigatorKey.currentState!.pop();
                              }
                            },
                            child: const Text("Save Changes"))
                      ],
                    )))));
  }
}

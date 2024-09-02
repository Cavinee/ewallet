import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  final TextEditingController controller;

  const UserName({super.key, required this.controller});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
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
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_3,
            color: focusNode.hasFocus ? Colors.teal : Colors.grey),
        labelText: "Username",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      controller: widget.controller,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill your user name";
        }
        return null;
      },
    );
  }
}
import 'package:flutter/material.dart';

class FullName extends StatefulWidget {
  final TextEditingController controller;

  const FullName({super.key, required this.controller});

  @override
  State<FullName> createState() => _FullNameState();
}

class _FullNameState extends State<FullName> {
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
        prefixIcon: Icon(Icons.person,
            color: focusNode.hasFocus ? Colors.teal : Colors.grey),
        labelText: "Full Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      controller: widget.controller,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill your full name";
        } else if (value.length < 5) {
          return "Full name must be at least 5 characters long";
        }
        return null;
      },
    );
  }
}

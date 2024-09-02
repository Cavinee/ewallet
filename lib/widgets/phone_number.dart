import 'package:flutter/material.dart';

class PhoneNumber extends StatefulWidget {
  final TextEditingController controller;

  const PhoneNumber({super.key, required this.controller});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
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
        prefixIcon: Icon(Icons.phone,
            color: focusNode.hasFocus ? Colors.teal : Colors.grey),
        labelText: "Phone Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill your phone number";
        }
        return null;
      },
    );
  }
}
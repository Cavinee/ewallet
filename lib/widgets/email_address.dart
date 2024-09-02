import 'package:flutter/material.dart';

class EmailAddress extends StatefulWidget {
  final TextEditingController controller;

  const EmailAddress({super.key, required this.controller});

  @override
  State<EmailAddress> createState() => _EmailAddressState();
}

class _EmailAddressState extends State<EmailAddress> {
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
        prefixIcon: Icon(Icons.email_rounded,
            color: focusNode.hasFocus ? Colors.teal : Colors.grey),
        labelText: "Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill your email address";
        } else if (!value.contains('@')) {
          return "Email address should have @";
        }
        return null;
      },
    );
  }
}

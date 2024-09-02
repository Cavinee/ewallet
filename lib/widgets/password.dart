import 'package:flutter/material.dart';

class PasswordSignUp extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController confirmController;

  const PasswordSignUp(
      {super.key, required this.controller, required this.confirmController});

  @override
  State<PasswordSignUp> createState() => _PasswordSignUpState();
}

class _PasswordSignUpState extends State<PasswordSignUp> {
  @override
  Widget build(BuildContext context) {
    FocusNode focusNodePassword = FocusNode();
    FocusNode focusNodeConfirm = FocusNode();

    @override
    void initState() {
      focusNodePassword.addListener(() {
        setState(() {});
      });

      focusNodeConfirm.addListener(() {
        setState(() {});
      });
      super.initState();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: focusNodePassword,
            decoration: InputDecoration(
          prefixIcon: Icon(Icons.password,
              color: focusNodePassword.hasFocus ? Colors.teal : Colors.grey),
          labelText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
                ),
            obscureText: true,
            controller: widget.controller,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please fill your password";
              } else if (value != widget.confirmController.text) {
                return "Please match your password";
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: focusNodeConfirm,
            decoration: InputDecoration(
          prefixIcon: Icon(Icons.password,
              color: focusNodeConfirm.hasFocus ? Colors.teal : Colors.grey),
          labelText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
                ),
            obscureText: true,
            controller: widget.confirmController,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              } else if (value != widget.controller.text) {
                return "Please match your password";
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

class PasswordLogin extends StatefulWidget {
  final TextEditingController controller;

  const PasswordLogin({super.key, required this.controller});

  @override
  State<PasswordLogin> createState() => _PasswordLoginState();
}

class _PasswordLoginState extends State<PasswordLogin> {
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
        prefixIcon: Icon(Icons.password,
            color: focusNode.hasFocus ? Colors.teal : Colors.grey),
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      obscureText: true,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please fill your password";
        }
        return null;
      },
    );
  }
}

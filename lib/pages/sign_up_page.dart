import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/email_address.dart';
import '../widgets/user_name.dart';
import '../widgets/full_name.dart';
import '../widgets/phone_number.dart';
import '../widgets/password.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _emailAddressController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    _emailAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
        body: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 100.0),
          margin: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FullName(controller: _fullNameController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UserName(controller: _userNameController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PhoneNumber(controller: _phoneNumberController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EmailAddress(controller: _emailAddressController),
              ),
              PasswordSignUp(
                controller: _passwordController,
                confirmController: _confirmPasswordController,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                            minimumSize: const Size(340,40),
                            backgroundColor: Colors.teal
                          ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await userProvider.signUp(
                            fullName: _fullNameController.text.trim(),
                            emailAddress: _emailAddressController.text.trim(),
                            password: _passwordController.text.trim(),
                            userName: _userNameController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim());
                      }
                    },
                    child: const Text("Create your account", style: TextStyle(color: Colors.white),)),
              ),
            ],
          )),
    )));
  }
}

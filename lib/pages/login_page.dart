import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/email_address.dart';
import '../widgets/password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  late final AnimationController emailAddressAnimationController;
  late final AnimationController passwordAnimationController;

  @override
  void dispose() {
    _emailAddressController.dispose();
    _passwordController.dispose();
    emailAddressAnimationController.dispose();
    passwordAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailAddressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    passwordAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(Duration.zero, () {
      emailAddressAnimationController.forward();
    }).then((_) => Future.delayed(const Duration(milliseconds: 200), () {
      passwordAnimationController.forward();
    }));;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 250.0),
                  margin: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          AnimatedBuilder(
                            animation: emailAddressAnimationController,
                            builder: (context, child) {
                              final slideAnimation = CurvedAnimation(
                                parent: emailAddressAnimationController,
                                curve: Curves.easeInOutCubic,
                              );

                              final offset = Tween<Offset>(
                                begin: const Offset(-1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              ).animate(slideAnimation);

                              return SlideTransition(
                                position: offset,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EmailAddress(
                                    controller: _emailAddressController,
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: passwordAnimationController,
                            builder: (context, child) {
                              final slideAnimation = CurvedAnimation(
                                parent: passwordAnimationController,
                                curve: Curves.easeInOutCubic,
                              );

                              final offset = Tween<Offset>(
                                begin: const Offset(-1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              ).animate(slideAnimation);

                              return SlideTransition(
                                position: offset,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PasswordLogin(controller: _passwordController),
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(340, 40),
                                backgroundColor: Colors.teal
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await userProvider.login(
                                      emailAddress:
                                          _emailAddressController.text,
                                      password: _passwordController.text);
                                }
                              },
                              child: const Text("Login", style: TextStyle(color: Colors.white))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Haven't created an account?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: const Text("Sign Up"))
                            ]),
                      )
                    ],
                  ))),
        ));
  }
}

import 'package:ewallet/models/user_provider.dart';
import 'package:ewallet/pages/home_page.dart';
import 'package:ewallet/pages/loading_screen.dart';
import 'package:ewallet/pages/login_page.dart';
import 'package:ewallet/pages/sign_up_page.dart';
import 'package:ewallet/pages/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'keys/snackbar_key.dart';
import 'keys/navigator_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
              textTheme:
                  GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
              ),
          scaffoldMessengerKey: snackbarKey,
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginPage(),
            '/signup': (context) => const SignUpPage(),
            '/home': (context) => const HomePage(),
            '/profile': (context) => const EditProfile(),
            '/loading': (context) => const LoadingScreen()
          },
          debugShowCheckedModeBanner: false,
        );
  }
}

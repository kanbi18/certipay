import 'package:certipay/views/auth/verify_email_view.dart';
import 'package:certipay/views/main-ui/home_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:certipay/firebase_options.dart';
import 'package:certipay/views/auth/login_view.dart';
import 'package:certipay/views/auth/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      "/login": (context) => const LoginView(),
      "/register": (context) => const RegisterView(),
      "/verify-email": (context) => const VerifyEmailView(),
      "/home": (context) => const HomeView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if (user != null) {
              if (user.emailVerified) {
                /** Move into app screen */
                return const LoginView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

import 'package:certipay/constants/routes.dart';
import 'package:certipay/views/auth/verify_email_view.dart';
import 'package:certipay/views/main_ui/contracts/contract_list_view.dart';
import 'package:certipay/views/main_ui/contracts/contracts_view.dart';
import 'package:certipay/views/main_ui/contracts/create_contract_view.dart';
import 'package:certipay/views/main_ui/home_view.dart';
import 'package:certipay/views/main_ui/setup_view.dart';
import 'package:certipay/views/staple/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:certipay/views/auth/login_view.dart';
import 'package:certipay/views/staple/profile/profile_view.dart';
import 'package:certipay/views/auth/register_view.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:certipay/services/auth/bloc/auth_bloc.dart';
import 'package:certipay/services/auth/bloc/auth_event.dart';
import 'package:certipay/services/auth/bloc/auth_state.dart';
import 'package:certipay/services/auth/firebase_auth_provider.dart';
import 'package:certipay/utilities/screens/loading/loading_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final authBloc = AuthBloc(FirebaseAuthProvider());
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => authBloc,
      child: const HomePage(),
    ),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      homeRoute: (context) => const HomeView(),
      settingsRoute: (context) => const SettingsView(),
      createContractRoute: (context) => CreateContractView(),
      contractsRoute: (context) => const ContractsView(),
      profileRoute: (context) => BlocProvider<AuthBloc>.value(
            value: AuthBloc(FirebaseAuthProvider()),
            child: const ProfileView(),
          ),
      //profileRoute: (context) => const ProfileView(),
      setupRoute: (context) => const SetupView()
    },
    onUnknownRoute: (RouteSettings settings) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) =>
            const Scaffold(body: Center(child: Text('Not Found'))),
      );
    },
  ));
  FlutterNativeSplash.remove();
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const SetupView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

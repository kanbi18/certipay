import 'package:certipay/constants/routes.dart';
import 'package:certipay/services/auth/bloc/auth_event.dart';
import 'package:certipay/services/auth/bloc/auth_state.dart';
import 'package:certipay/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_item.dart';
import 'profile_picture.dart';
import 'package:certipay/services/auth/bloc/auth_bloc.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(loginRoute, (route) => false);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const ProfilePicture(),
            const SizedBox(
              height: 20,
            ),
            ProfileItem(
                text: "My Account",
                icon: const Icon(
                  Icons.supervised_user_circle,
                ),
                onPressed: () {}),
            ProfileItem(
              text: "Notifications",
              icon: const Icon(Icons.supervised_user_circle),
              onPressed: () {},
            ),
            ProfileItem(
              text: "Settings",
              icon: const Icon(Icons.supervised_user_circle),
              onPressed: () {
                Navigator.of(context).pushNamed(settingsRoute);
              },
            ),
            ProfileItem(
              text: "Help Center",
              icon: const Icon(Icons.supervised_user_circle),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

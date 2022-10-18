import 'package:certipay/constants/routes.dart';
import 'package:flutter/material.dart';
import '../../../../services/auth/auth_service.dart';
import 'profile_item.dart';
import 'profile_picture.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            onPressed: () {},
          ),
          ProfileItem(
            text: "Help Center",
            icon: const Icon(Icons.supervised_user_circle),
            onPressed: () {
              Navigator.of(context).pushNamed(settingsRoute);
            },
          ),
          ProfileItem(
              text: "Log Out",
              icon: const Icon(Icons.supervised_user_circle),
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }
              }),
        ],
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

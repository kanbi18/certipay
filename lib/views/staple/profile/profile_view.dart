import 'package:flutter/material.dart';
import 'components/profile_content.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: const ProfileContent(),
    );
  }
}

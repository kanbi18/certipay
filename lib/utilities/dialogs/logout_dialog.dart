import 'package:flutter/material.dart';
import 'package:certipay/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log out",
    content: "Are you sure you want to log out?",
    optionsBuilder: () => {
      "cancel": false,
      "ok": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

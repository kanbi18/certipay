import 'package:flutter/material.dart';
import 'package:certipay/utilities/dialogs/generic_dialog.dart';

Future<bool> showCancelDialog(BuildContext context) {
  print("dialog cancel");
  return showGenericDialog<bool>(
    context: context,
    title: "Cancel contract",
    content: "Do you want to cancel this contract?",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

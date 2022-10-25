import 'package:flutter/material.dart';
import 'package:certipay/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "error",
    content: text,
    optionsBuilder: () => {
      "ok": null,
    },
  );
}

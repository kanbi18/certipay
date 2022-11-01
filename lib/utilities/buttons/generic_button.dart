import 'package:flutter/material.dart';

typedef OnPressed = void Function();

class GenericButton extends StatelessWidget {
  const GenericButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.dimensions = const [20.0, 100.0]});

  final String text;
  final OnPressed onPressed;
  // vertical, horizontal
  final List dimensions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: colorScheme.secondary,
          padding: EdgeInsets.symmetric(
              vertical: dimensions.first, horizontal: dimensions.last),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: (() {
          onPressed.call();
        }),
        child: Text(text));
  }
}

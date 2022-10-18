import 'package:certipay/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:certipay/constants/colors.dart' as theme;

class SetupView extends StatefulWidget {
  const SetupView({super.key});

  @override
  State<SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(theme.backgroundColor),
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome! Let's begin setup.",
                  style: TextStyle(
                      color: Color(theme.buttonColor),
                      fontSize: 24,
                      fontFamily: "Montserrat")),
              const SetupItem(
                  helperText: "Choose your network:",
                  icon: Icons.person_outlined,
                  options: ["ETH", "RTF", "PRD"]),
              const SetupItem(
                  helperText: "Choose your use-case:",
                  icon: Icons.description_outlined,
                  options: ["Health", "Sports", "Habits"]),
              const SetupItem(
                  helperText: "Choose your currency:",
                  icon: Icons.paid_outlined,
                  options: ["USD", "EUR", "GBP"]),
              const SetupItem(
                  helperText: "Based on use case:",
                  icon: Icons.paid_outlined,
                  options: ["One", "Two", "Three"]),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(theme.buttonColor),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (() {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeRoute, (_) => false);
                  }),
                  child: const Text("Confirm"))
            ],
          ),
        ));
  }
}

class SetupItem extends StatefulWidget {
  const SetupItem(
      {super.key,
      required this.helperText,
      required this.icon,
      required this.options});

  final IconData icon;
  final String helperText;
  final List<String> options;

  @override
  State<SetupItem> createState() => _SetupItemState();
}

class _SetupItemState extends State<SetupItem> {
  late String dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.helperText,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            style: const TextStyle(
              color: Colors.black,
            ),
            elevation: 16,
            underline: const SizedBox(),
            items: widget.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

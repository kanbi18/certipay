import 'package:certipay/views/main_ui/contracts/contracts_view.dart';
import 'package:flutter/material.dart';
import 'package:certipay/constants/routes.dart';
import 'package:certipay/enums/menu_actions.dart';
import 'package:certipay/services/auth/auth_service.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:certipay/constants/routes.dart';
import 'package:certipay/services/auth/auth_service.dart';
import 'package:certipay/services/auth/bloc/auth_bloc.dart';
import 'package:certipay/services/auth/bloc/auth_event.dart';
import 'package:certipay/services/contracts/contract.dart';
import 'package:certipay/services/cloud/firebase_cloud_storage.dart';
import 'package:certipay/utilities/dialogs/logout_dialog.dart';
import 'package:certipay/views/main_ui/contracts/contract_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

import '../../utilities/dialogs/logout_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _cloudStorage;
  String get userId => AuthService.firebase().currentUser!.id;
  late Stream<Iterable<Contract>> contractStream;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
    contractStream = _cloudStorage.getAllNotes(owner: userId);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createContractRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: const Text(
                'Hello, Stranger',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            const ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends'),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(profileRoute);
              },
            ),
          ],
        ),
      ),
      body: Column(children: [
        Container(
          height: 50.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              CategoryChip(
                chipText: "Health",
                colorScheme: colorScheme,
              ),
              CategoryChip(
                chipText: "Sport",
                colorScheme: colorScheme,
              ),
              CategoryChip(
                chipText: "Habits",
                colorScheme: colorScheme,
              ),
              CategoryChip(
                chipText: "Generic",
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        const Expanded(child: ContractsView()),
      ]),
    );
  }
}

class CategoryChip extends StatelessWidget {
  CategoryChip({
    super.key,
    required this.chipText,
    required this.colorScheme,
    this.chipIcon,
  });

  final String chipText;
  final ColorScheme colorScheme;
  final Icon? chipIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150.0,
      margin: const EdgeInsets.all(5.0),
      child: ActionChip(
        label: Text(chipText),
        onPressed: () {},
      ),
    );
  }
}

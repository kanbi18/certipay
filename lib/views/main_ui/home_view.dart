import 'dart:async';

import 'package:certipay/utilities/models/contracts_model.dart';
import 'package:certipay/views/main_ui/contracts/contracts_view.dart';
import 'package:flutter/material.dart';
import 'package:certipay/constants/routes.dart';
import 'package:certipay/enums/menu_actions.dart';
import 'package:certipay/services/auth/auth_service.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/foundation.dart';
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
import 'package:provider/provider.dart';

import '../../utilities/dialogs/logout_dialog.dart';

//Stream<List<String>> categories = const Stream.empty();
List<String> categories = [];
List<String> allCategories = [
  "Health",
  "Sport",
  "Habits",
  "Generic",
];

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _cloudStorage;
  String get userId => AuthService.firebase().currentUser!.id;
  late StreamController<Iterable<Contract>> contractStreamController;
  late Stream<Iterable<Contract>> contractStream;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
    contractStreamController = StreamController<Iterable<Contract>>();
    contractStream = contractStreamController.stream;

    //contractStream = _cloudStorage.getAllNotes(owner: userId);
  }

  void updateController() {
    Provider.of<ContractsModel>(context, listen: false)
        .updateContractsCategory(categories);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createContractRoute);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              }
            },
            icon: const Icon(Icons.logout),
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
                  chipText: "All", streamControllerCallback: updateController),
              CategoryChip(
                  chipText: "Health",
                  streamControllerCallback: updateController),
              CategoryChip(
                  chipText: "Sport",
                  streamControllerCallback: updateController),
              CategoryChip(
                  chipText: "Habits",
                  streamControllerCallback: updateController),
              CategoryChip(
                  chipText: "Generic",
                  streamControllerCallback: updateController),
            ],
          ),
        ),
        Expanded(
          child: ContractsView(),
        )
      ]),
    );
  }
}

typedef StreamControllerCallback = Function();

class CategoryChip extends StatefulWidget {
  CategoryChip({
    super.key,
    required this.chipText,
    required this.streamControllerCallback,
    this.chipIcon,
    this.backgroundColor = Colors.white,
  });

  final String chipText;
  final StreamControllerCallback streamControllerCallback;
  Color backgroundColor;
  final Icon? chipIcon;

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  void _handlePress() {
    setState(() {
      if (widget.backgroundColor == Colors.white) {
        // widget.colorScheme.primary
        widget.backgroundColor = Theme.of(context).colorScheme.primary;
        if (widget.chipText == "All") {
          categories.addAll(allCategories);
        } else {
          categories.add(widget.chipText);
        }
      } else {
        widget.backgroundColor = Colors.white;
        if (widget.chipText == "All") {
          for (String category in allCategories) {
            categories.remove(category);
          }
        } else {
          categories.remove(widget.chipText);
        }
      }
      widget.streamControllerCallback();

      print(categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(),
      //margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),

      child: ActionChip(
        label: Text(widget.chipText),
        onPressed: _handlePress,
        backgroundColor: widget.backgroundColor,
      ),
    );
  }
}

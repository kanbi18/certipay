import 'package:certipay/views/main_ui/contracts/contracts_view.dart';
import 'package:flutter/material.dart';
import 'package:certipay/constants/routes.dart';
import 'package:certipay/enums/menu_actions.dart';
import 'package:certipay/services/auth/auth_service.dart';

import '../../utilities/dialogs/logout_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createContractRoute);
            },
            icon: const Icon(Icons.add),
          ),
          // PopupMenuButton<MenuAction>(
          //   onSelected: (value) async {
          //     switch (value) {
          //       case MenuAction.logout:
          //         final shouldLogout = await showLogOutDialog(context);
          //         if (shouldLogout) {
          //           context.read<AuthBloc>().add(
          //                 const AuthEventLogOut(),
          //               );
          //         }
          //     }
          //   },
          //   itemBuilder: (context) {
          //     return [
          //       PopupMenuItem<MenuAction>(
          //         value: MenuAction.logout,
          //         child: Text(context.loc.logout_button),
          //       ),
          //     ];
          //   },
          // )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
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
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('My Contracts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(contractsRoute, (route) => false);
              },
            ),
          ],
        ),
      ),
      body: const Text('Hello world'),
    );
  }
}

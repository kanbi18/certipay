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

class ContractsView extends StatefulWidget {
  const ContractsView({super.key});

  @override
  State<ContractsView> createState() => _ContractsViewState();
}

class _ContractsViewState extends State<ContractsView> {
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
    return Scaffold(
      body: StreamBuilder(
        stream: _cloudStorage.getAllNotes(owner: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allContracts = snapshot.data as Iterable<Contract>;
                return ContractListView(
                  contracts: allContracts,
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

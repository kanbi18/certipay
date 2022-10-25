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

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: _cloudStorage.getAllNotes(owner: userId).getLength,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final contractCount = snapshot.data ?? 0;
              return Text("$contractCount contracts");
            } else {
              return const Text("0 contracts");
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createContractRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _cloudStorage.getAllNotes(owner: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                print("Test");
                final allContracts = snapshot.data as Iterable<Contract>;
                print(allContracts);
                return ContractListView(
                  contracts: allContracts,
                  onCancelContract: (contract) async {
                    await _cloudStorage.deleteContract(
                        contractId: contract.contractId);
                  },
                  onTap: (contract) {
                    Navigator.of(context).pushNamed(
                      createContractRoute,
                      arguments: contract,
                    );
                  },
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

import 'package:certipay/services/contracts/contract.dart';
import 'package:flutter/foundation.dart';

import 'package:certipay/utilities/models/contracts_model.dart';
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
import 'package:provider/provider.dart';

class ContractsModel extends ChangeNotifier {
  Stream<Iterable<Contract>> contractsStream = const Stream.empty();
  Iterable<Contract> allContracts = List.empty();
  Iterable<Contract> contractsInUse = List.empty();

  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();
  String get userId => AuthService.firebase().currentUser!.id;

  // void updateContractsViaStream() async {
  //   contracts = await contractsStream.last;
  //   print(contracts);
  //   Future.delayed(Duration.zero, () {
  //     notifyListeners();
  //   });
  // }

  void updateContracts(Iterable<Contract> contracts) {
    allContracts = contracts;
    contractsInUse = allContracts;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  void updateContractsCategory(List<String> categories) {
    print("category");
    print(allContracts);
    contractsInUse = allContracts.where((contract) {
      print(contract.category.name);
      return categories.contains(contract.category.name);
    });
    print(contractsInUse);
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  // void defaultStream() async {
  //   contractsStream = _cloudStorage.getAllNotes(owner: userId);
  //   print(contractsStream);
  //   updateContractsViaStream();
  // }

  ///  implement category filtering
  ///  change streams based on category selected
  ///  if category stream.last is [] => default is getAllNotes
  // void filterCategory(List<String> categories) {
  //   if (categories.isEmpty) {
  //     defaultStream();
  //   } else {
  //     contractsStream = _cloudStorage.getAllNotesFromCategory(
  //         owner: userId, categories: categories);
  //     updateContractsViaStream();
  //   }
  // }
}

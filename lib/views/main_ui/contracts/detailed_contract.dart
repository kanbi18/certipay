import 'package:certipay/enums/menu_actions.dart';
import 'package:certipay/services/auth/auth_service.dart';
import 'package:certipay/services/cloud/firebase_cloud_storage.dart';
import 'package:certipay/services/contracts/contract.dart';
import 'package:certipay/utilities/buttons/generic_button.dart';
import 'package:certipay/utilities/dialogs/cancel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:certipay/constants/app_theme.dart';

class DetailedContractView extends StatefulWidget {
  const DetailedContractView({
    super.key,
    required this.contract,
  });

  final Contract contract;

  @override
  State<DetailedContractView> createState() => _DetailedContractViewState();
}

class _DetailedContractViewState extends State<DetailedContractView> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.contract.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          EditContract(contract: widget.contract)),
                  ModalRoute.withName("/"));
            },
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton<DetailedContractMenu>(
            itemBuilder: (context) {
              return [
                PopupMenuItem<DetailedContractMenu>(
                  child: const Text("Delete"),
                  onTap: () async {
                    Future.delayed(const Duration(seconds: 0), (() async {
                      return await showCancelDialog(context);
                    })).then((shouldCancel) async {
                      if (shouldCancel) {
                        await _cloudStorage.deleteContract(
                            contractId: widget.contract.contractId);
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    });
                  },
                ),
                PopupMenuItem<DetailedContractMenu>(
                  child: const Text("Add Stakeholder"),
                  onTap: () {},
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 100),
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Text(widget.contract.description ?? widget.contract.title),
            ),
          ),
        ],
      ),
    );
  }
}

class EditContract extends StatefulWidget {
  const EditContract({super.key, required this.contract});

  final Contract contract;

  @override
  State<EditContract> createState() => _EditContractState();
}

class _EditContractState extends State<EditContract> {
  late final FirebaseCloudStorage _cloudStorage;
  late final TextEditingController _titleTextController =
      TextEditingController();
  late final TextEditingController _descriptionTextController =
      TextEditingController();

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    // TODO: implement initState
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit contract"),
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: TextFormField(
              controller: _titleTextController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter new title"),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: TextFormField(
              controller: _descriptionTextController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter new description"),
            ),
          ),
          const SizedBox(
            width: 50,
            height: 50,
          ),
          GenericButton(
            onPressed: () {
              _cloudStorage.updateContract(
                  contractId: widget.contract.contractId,
                  text: _titleTextController.text);
            },
            text: "Save changes",
            dimensions: const [15.0, 20.0],
          ),
        ],
      ),
    );
  }
}

import 'package:certipay/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:certipay/services/auth/auth_service.dart';
import 'package:certipay/services/contracts/contract.dart';
import 'package:certipay/services/cloud/firebase_cloud_storage.dart';

class CreateContractView extends StatefulWidget {
  CreateContractView({super.key});

  final List<String> categories =
      Category.values.map((category) => categoryToString(category)).toList();

  @override
  State<CreateContractView> createState() => _CreateContractViewState();
}

class _CreateContractViewState extends State<CreateContractView> {
  Contract? _contract;
  late final FirebaseCloudStorage _cloudStorage;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final String _category;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _category = widget.categories.first;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deleteContractIfTextIsEmpty();
    super.dispose();
  }

  void _textControllerListener() async {
    final contract = _contract;
    if (contract == null) {
      return;
    }
    final text = _titleController.text;
    await _cloudStorage.updateContract(
      contractId: contract.contractId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _titleController.removeListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
  }

  Future<Contract> createOrGetExistingContract(BuildContext context) async {
    final widgetContract = context.getArgument<Contract>();

    if (widgetContract != null) {
      _contract = widgetContract;
      _titleController.text = widgetContract.title;
      return widgetContract;
    }

    final existingContract = _contract;
    if (existingContract != null) {
      return existingContract;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newContract = await _cloudStorage.createContract(
        title: _titleController.text,
        description: _descriptionController.text,
        category: Category.generic,
        owners: [userId],
        stakeholders: []);
    _contract = newContract;
    return newContract;
  }

  void _deleteContractIfTextIsEmpty() {
    final contract = _contract;
    if (_titleController.text.isEmpty && contract != null) {
      _cloudStorage.deleteContract(contractId: contract.contractId);
    }
  }

  //   void _saveNoteIfTextNotEmpty() async {
  //   final note = _note;
  //   final text = _textController.text;
  //   if (note != null && text.isNotEmpty) {
  //     await _notesService.updateNote(
  //       documentId: note.documentId,
  //       text: text,
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   _deleteNoteIfTextIsEmpty();
  //   _saveNoteIfTextNotEmpty();
  //   _textController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contract",
        ),
      ),
      body: FutureBuilder(
        future: createOrGetExistingContract(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Column(children: [
                TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Contract Title",
                    )),
                TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Contract Description",
                    )),
                DropdownButton<String>(
                    isExpanded: true,
                    value: _category,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    elevation: 16,
                    underline: const SizedBox(),
                    items: widget.categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _category = value!;
                      });
                    })
              ]);
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

String categoryToString(Category category) {
  String categoryName = category.name;
  String capital = categoryName.characters.first.toUpperCase();
  return categoryName.replaceRange(0, 1, capital);
}

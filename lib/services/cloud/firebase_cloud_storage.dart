import 'package:certipay/services/cloud/cloud_constants.dart';
import 'package:certipay/services/cloud/cloud_exceptions.dart';
import 'package:certipay/services/contracts/contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  factory FirebaseCloudStorage() => _singleton;
  FirebaseCloudStorage._internal();
  static final FirebaseCloudStorage _singleton =
      FirebaseCloudStorage._internal();

  final contracts = FirebaseFirestore.instance.collection("contracts");

  Future<Contract> createContract({
    required String title,
    required String description,
    required Category category,
    required List<String> owners,
    required List<String> stakeholders,
  }) async {
    final contractRef = await contracts.add({
      titleFieldName: title,
      descriptionFieldName: description,
      categoryFieldName: category,
      ownersFieldName: owners,
      stakeholdersFieldName: stakeholders,
      lastUpdatedFieldName: DateTime.now()
    });
    final contract = await contractRef.get();

    return Contract(
        contractId: contract.id,
        title: title,
        owners: owners,
        lastUpdated: DateTime.now());
  }

  Future<Iterable<Contract>> getContracts({required String owner}) async {
    try {
      return await contracts
          .where(ownersFieldName, arrayContains: owner)
          .get()
          .then((value) => value.docs.map(
                (snapshot) => Contract.fromSnapshot(snapshot),
              ));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<Contract>> getAllNotes({required String owner}) {
    return contracts.snapshots().map((event) => event.docs
        .map((doc) => Contract.fromSnapshot(doc))
        .where((contract) => contract.owners!.contains(owner)));
  }

  Future<void> updateContract(
      {required String contractId, required String text}) async {
    try {
      await contracts.doc(contractId).update({titleFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteContract({required String contractId}) async {
    try {
      await contracts.doc(contractId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}

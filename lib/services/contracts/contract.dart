import 'package:certipay/services/cloud/cloud_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Contract {
  final String contractId;
  final String title;
  final String? description;
  final Category category;
  final List<String> owners;
  final List<String>? stakeholders;
  final DateTime lastUpdated;

  const Contract({
    required this.contractId,
    required this.title,
    required this.owners,
    required this.lastUpdated,
    this.description,
    this.category = Category.generic,
    this.stakeholders,
  });

  Contract.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : contractId = snapshot.id,
        title = snapshot.data()[titleFieldName] as String,
        description = snapshot.data()[descriptionFieldName] as String,
        category = snapshot.data()[categoryFieldName] as Category,
        owners = snapshot.data()[ownersFieldName],
        stakeholders = snapshot.data()[stakeholdersFieldName],
        lastUpdated = snapshot.data()[lastUpdatedFieldName];
}

enum Category { health, sports, habits, generic }

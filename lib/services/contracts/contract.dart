import 'package:certipay/services/cloud/cloud_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Contract {
  final String contractId;
  final String title;
  final String? description;
  final Category category;
  final List<String>? owners;
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
        category = categoryFromString(snapshot.data()[categoryFieldName]),
        owners = getString(snapshot.data()[ownersFieldName]),
        stakeholders = getString(snapshot.data()[stakeholdersFieldName]),
        lastUpdated = (snapshot.data()[lastUpdatedFieldName]).toDate();

  factory Contract.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Contract(
      contractId: snapshot.id,
      title: data?[titleFieldName],
      description: data?[descriptionFieldName],
      category: data?[categoryFieldName],
      owners: List.from(data?[ownersFieldName]),
      stakeholders: data?[stakeholdersFieldName] is Iterable
          ? List.from(data?[stakeholdersFieldName])
          : null,
      lastUpdated: data?[lastUpdatedFieldName],
    );
  }
}

enum Category { health, sports, habits, generic }

final categoryMap = {
  "health": Category.health,
  "sports": Category.sports,
  "habits": Category.habits,
  "generic": Category.generic,
};

Category categoryFromString(String category) {
  return categoryMap[category]!;
}

List<String> getString(List<dynamic> snapshot) {
  List<String> toString;
  toString = snapshot.map((item) => item as String).toList();

  return toString;
}

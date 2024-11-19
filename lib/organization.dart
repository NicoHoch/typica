import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typica/utils/enums.dart';

class Organization {
  const Organization({
    required this.organizationName,
    required this.organizationGUID,
    required this.organizationType,
    required this.createdFrom,
    required this.timestamp,
  });

  final String organizationName;
  final String organizationGUID;
  final OrganizationType organizationType;
  final String createdFrom;
  final int timestamp;

  // Convert a Firestore document to a organizationEntry instance
  factory Organization.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Organization(
      organizationName: data['organizationName'] as String,
      organizationGUID: data['organizationGUID'] as String,
      organizationType: OrganizationType.values.firstWhere(
        (e) => e.name == data['organizationType'],
        orElse: () => OrganizationType.customer,
      ),
      createdFrom: data['createdFrom'] as String,
      timestamp: data['timestamp'] as int,
    );
  }

  // Convert a organizationEntry instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'organizationName': organizationName,
      'organizationGUID': organizationGUID,
      'organizationType': organizationType.name,
      'createdFrom': createdFrom,
      'timestamp': timestamp,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerEntry {
  const CustomerEntry({
    required this.customerName,
    required this.customerGUID,
    required this.createdFrom,
    required this.timestamp,
    required this.userId,
  });

  final String customerName;
  final String customerGUID;
  final String createdFrom;
  final int timestamp;
  final String userId;

  // Convert a Firestore document to a CustomerEntry instance
  factory CustomerEntry.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CustomerEntry(
      customerName: data['customerName'] as String,
      customerGUID: data['customerGUID'] as String,
      createdFrom: data['createdFrom'] as String,
      timestamp: data['timestamp'] as int,
      userId: data['userId'] as String,
    );
  }

  // Convert a CustomerEntry instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'customerName': customerName,
      'customerGUID': customerGUID,
      'createdFrom': createdFrom,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}

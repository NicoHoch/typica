import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'customer_entry.dart';

import 'package:uuid/uuid.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _customerSubscription;
  List<CustomerEntry> _customerEntries = [];
  List<CustomerEntry> get customerEntries => _customerEntries;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _customerSubscription = FirebaseFirestore.instance
            .collection('customers')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _customerEntries = snapshot.docs
              .map((doc) => CustomerEntry.fromFirestore(doc))
              .toList();
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _customerEntries = [];
        _customerSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> saveCustomerToFirebase(String customerName) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final newCustomer = CustomerEntry(
      customerName: customerName,
      customerGUID: const Uuid().v4(),
      createdFrom: FirebaseAuth.instance.currentUser!.displayName ?? '',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );

    return FirebaseFirestore.instance
        .collection('customers')
        .add(newCustomer.toFirestore());
  }
}

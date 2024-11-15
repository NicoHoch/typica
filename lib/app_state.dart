import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'customer_entry.dart';

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
          _customerEntries = [];
          for (final document in snapshot.docs) {
            _customerEntries.add(
              CustomerEntry(
                customerName: document.data()['customerName'] as String,
                createdFrom: document.data()['createdFrom'] as String,
              ),
            );
          }
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

  Future<DocumentReference> saveCustomerToFirebase(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('customers')
        .add(<String, dynamic>{
      'customerName': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'createdFrom': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}

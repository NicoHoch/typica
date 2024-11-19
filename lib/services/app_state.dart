import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:typica/utils/enums.dart';

import '../firebase_options.dart';
import '../models/organization.dart';

import 'package:uuid/uuid.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _customerSubscription;
  List<Organization> _customerEntries = [];
  List<Organization> get customerEntries => _customerEntries;

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
            .collection('Organization')
            .where('organizationType',
                isEqualTo: OrganizationType.customer.name)
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _customerEntries = snapshot.docs
              .map((doc) => Organization.fromFirestore(doc))
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

  Future<DocumentReference> saveOrganizationToFirebase(
      String customerName, OrganizationType organizationType) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final newCustomer = Organization(
      organizationName: customerName,
      organizationGUID: const Uuid().v4(),
      organizationType: organizationType,
      createdFrom: FirebaseAuth.instance.currentUser!.uid,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    return FirebaseFirestore.instance
        .collection('Organization')
        .add(newCustomer.toFirestore());
  }
}

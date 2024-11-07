import 'package:flutter/material.dart';

class ManageCustomerPage extends StatelessWidget {
  const ManageCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kunden'),
      ),
      body: Center(
        child: Text('Customer data will be displayed here.'),
      ),
    );
  }
}

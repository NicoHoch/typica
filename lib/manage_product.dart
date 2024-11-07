import 'package:flutter/material.dart';

class ManageProductPage extends StatelessWidget {
  const ManageProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produkte'),
      ),
      body: Center(
        child: Text('Products data will be displayed here.'),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:typica/src/widgets.dart';

class ManageCustomerPage extends StatefulWidget {
  const ManageCustomerPage({required this.saveCustomer, super.key});

  final FutureOr<void> Function(String message) saveCustomer;

  @override
  State<ManageCustomerPage> createState() => _ManageCustomerPageState();
}

class _ManageCustomerPageState extends State<ManageCustomerPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ManageCustoerPageState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Kundenname',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Kundennamen ein';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            StyledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await widget.saveCustomer(_controller.text);
                    _controller.clear();
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 4),
                    Text('Speichern')
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

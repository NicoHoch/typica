import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';

class MainScaffold extends StatelessWidget {
  final Widget body; // Page-specific content

  const MainScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typica App'),
        actions: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) {
              if (appState.loggedIn) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.dashboard),
                      onPressed: () {
                        context.push('/'); // Navigate to Übersicht
                      },
                      tooltip: 'Übersicht',
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag),
                      onPressed: () {
                        context.go('/product'); // Navigate to Produkte
                      },
                      tooltip: 'Produkte',
                    ),
                    IconButton(
                      icon: const Icon(Icons.people),
                      onPressed: () {
                        context.go('/customer'); // Navigate to Kunden
                      },
                      tooltip: 'Kunden',
                    ),
                    AuthFunc(
                      loggedIn: appState.loggedIn,
                      signOut: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                );
              } else {
                return AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  },
                );
              }
            },
          ),
        ],
      ),
      body: body,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typica App'),
        actions: [
          // Consumer to observe the logged-in state
          Consumer<ApplicationState>(
            builder: (context, appState, _) {
              if (appState.loggedIn) {
                // If logged in, show the "Übersicht", "Produkte", and "Kunden" cards in the AppBar
                return Row(
                  children: [
                    // "Übersicht" card/button
                    IconButton(
                      icon: const Icon(Icons.dashboard),
                      onPressed: () {
                        // Navigate to Übersicht page
                      },
                      tooltip: 'Übersicht',
                    ),
                    // "Produkte" card/button
                    IconButton(
                      icon: const Icon(Icons.shopping_bag),
                      onPressed: () {
                        // Navigate to Produkte page
                      },
                      tooltip: 'Produkte',
                    ),
                    // "Kunden" card/button
                    IconButton(
                      icon: const Icon(Icons.people),
                      onPressed: () {
                        // Navigate to Kunden page
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
                // If not logged in, show login button
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
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          // RSVP section for logged-in users
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appState.loggedIn
                    ? const Paragraph('Here, the actual app will be placed')
                    : const Paragraph(
                        'Welcome to Typica App - your order management platform. Log in to manage your orders'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

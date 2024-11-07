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
        title: const Text('Firebase Meetup'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const Header('Welcome to Firebase Meetup!'),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),

          // Display the AuthFunc widget for login and logout
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
              loggedIn: appState.loggedIn,
              signOut: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),

          const Divider(
            height: 8,
            thickness: 1,
            color: Colors.grey,
          ),

          // RSVP section for logged-in users
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appState.loggedIn
                    ? const Paragraph('You are logged in!')
                    : const Paragraph('Please log in to RSVP.'),
                if (appState.loggedIn) ...[
                  StyledButton(
                    onPressed: () {
                      // Action for RSVP
                    },
                    child: const Text('RSVP for the Event'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

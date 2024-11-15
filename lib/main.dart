// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:typica/main_scaffold.dart';
import 'package:typica/manage_customer.dart';
import 'package:typica/manage_product.dart';

import 'app_state.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

// Add GoRouter configuration outside the App class
final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Wrap MainScaffold around each child route
        return MainScaffold(body: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomePage()),
          routes: [
            GoRoute(
              path: 'customer',
              pageBuilder: (context, state) => NoTransitionPage(
                child: Consumer<ApplicationState>(
                  builder: (context, appState, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (appState.loggedIn) ...[
                        ManageCustomerPage(
                          saveCustomer: (message) =>
                              appState.saveCustomerToFirebase(message),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'product',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ManageProductPage(),
              ),
            ),
            GoRoute(
              path: 'sign-in',
              pageBuilder: (context, state) => NoTransitionPage(
                child: SignInScreen(
                  actions: [
                    ForgotPasswordAction(((context, email) {
                      final uri = Uri(
                        path: '/sign-in/forgot-password',
                        queryParameters: <String, String?>{
                          'email': email,
                        },
                      );
                      context.go(uri.toString());
                    })),
                    AuthStateChangeAction(((context, state) {
                      final user = switch (state) {
                        SignedIn state => state.user,
                        UserCreated state => state.credential.user,
                        _ => null
                      };
                      if (user == null) {
                        return;
                      }
                      if (state is UserCreated) {
                        user.updateDisplayName(user.email!.split('@')[0]);
                      }
                      if (!user.emailVerified) {
                        user.sendEmailVerification();
                        const snackBar = SnackBar(
                            content: Text(
                                'Please check your email to verify your email address'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      context.go('/');
                    })),
                  ],
                ),
              ),
              routes: [
                GoRoute(
                  path: 'forgot-password',
                  pageBuilder: (context, state) {
                    final arguments = state.uri.queryParameters;
                    return NoTransitionPage(
                      child: ForgotPasswordScreen(
                        email: arguments['email'],
                        headerMaxExtent: 200,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'profile',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ProfileScreen(
                  providers: const [],
                  actions: [
                    SignedOutAction((context) {
                      context.go('/');
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    )
  ],
);

// end of GoRouter configuration

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Firebase Meetup',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router, // new
    );
  }
}

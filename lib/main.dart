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
        return MainScaffold(body: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomePage()),
          routes: [
            // Customer Page
            GoRoute(
              path: 'customer',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ManageCustomerPage()),
            ),
            // Product Page
            GoRoute(
              path: 'product',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ManageProductPage()),
            ),
            // Sign-in Page
            GoRoute(
              path: 'sign-in',
              pageBuilder: (context, state) => NoTransitionPage(
                child: SignInScreen(
                  actions: [
                    // Actions for sign-in screen
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
            ),
            // Profile Page
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
    ),
  ],
  // Global redirect for authentication check
  redirect: (state) {
    final isLoggedIn = context.read<ApplicationState>().loggedIn;

    // Check if the user is trying to access restricted routes and is not logged in
    final isRestrictedRoute =
        state.location == '/customer' || state.location == '/product';
    if (!isLoggedIn && isRestrictedRoute) {
      // Redirect to home or sign-in page if not logged in
      return '/sign-in'; // Or '/' for home if you'd like
    }
    return null; // Allow navigation if the user is logged in or route is not restricted
  },
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

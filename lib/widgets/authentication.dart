// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return loggedIn
        ? PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                // Navigate to profile page with go_router
                context.push('/profile');
              } else if (value == 'logout') {
                // Sign out the user
                signOut();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              ),
            ],
            icon: const Icon(Icons.account_circle), // Profile icon
            tooltip: 'Profile and Logout',
          )
        : IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              // Navigate to sign-in page
              context.push('/sign-in');
            },
            tooltip: 'Login',
          );
  }
}

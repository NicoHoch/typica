import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typica/dashboard_page.dart';
import 'package:typica/welcome_page.dart';

import 'app_state.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return Center(
              child: appState.loggedIn
                  ? const DashboardPage()
                  : const WelcomePage());
        },
      ),
    );
  }
}

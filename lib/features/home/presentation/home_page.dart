import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/pages/intro_page.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      if (appState.isStarted == true) {
        return const IntroPage();
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Home Page'),
        ),
        body: const Center(
          child: Text('Hi there! This is the home page.'),
        ),
      );
    });
  }
}

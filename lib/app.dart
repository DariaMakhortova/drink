import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'screens/auth_screen.dart';
import 'state/app_controller.dart';
import 'theme/app_theme.dart';

class DrinkFlowApp extends StatelessWidget {
  const DrinkFlowApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drink Flow',
          theme: buildAppTheme(),
          home: controller.isLoggedIn
              ? AppShell(controller: controller)
              : AuthScreen(controller: controller),
        );
      },
    );
  }
}

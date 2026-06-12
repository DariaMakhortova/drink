import 'package:flutter/material.dart';

import 'app.dart';
import 'state/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final controller = await AppController.bootstrap();
  runApp(DrinkFlowApp(controller: controller));
}

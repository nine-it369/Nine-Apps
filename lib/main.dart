import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Clean Architecture Service Locator / Dependency Injection
  await configureDependencies();

  runApp(const NineApp());
}

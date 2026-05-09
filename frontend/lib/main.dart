import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/routes.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MedApp',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,
    );
  }
}

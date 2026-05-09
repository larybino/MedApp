import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/routes.dart';
import 'core/state/user_provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp.router(
        title: 'MedApp',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: Routes.router,
      ),
    );
  }
}

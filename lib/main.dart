import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'routes/app_routes.dart';

void main(List<String> args) {
  runApp(Communityapp());
}

class Communityapp extends StatelessWidget {
  const Communityapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Praktikum',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}

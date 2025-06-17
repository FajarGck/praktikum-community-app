import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';
import 'config/theme.dart';
import 'routes/app_routes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => KategoriProvider()),
      ],
      child: const Communityapp(),
    ),
  );
}

class Communityapp extends StatelessWidget {
  const Communityapp({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading) {
      return const MaterialApp(home: Scaffold(body: Loading()));
    }
    return MaterialApp(
      title: 'Community Praktikum',
      theme: AppTheme.lightTheme,
      initialRoute: auth.isLoggedIn ? AppRoutes.home : AppRoutes.login,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}

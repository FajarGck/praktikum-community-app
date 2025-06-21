import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/ui/widgets/wrapper.dart';
import 'config/theme.dart';
import 'routes/app_routes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthorProvider()),
        ChangeNotifierProvider(create: (_) => KategoriProvider()),
      ],
      child: const Communityapp(),
    ),
  );
}

class Communityapp extends StatelessWidget {
  const Communityapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Praktikum',
      theme: AppTheme.lightTheme,
      home: Wrapper(),
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}

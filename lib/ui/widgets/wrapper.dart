import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/ui/pages/auth/login_page.dart';
import 'package:tugas_akhir/ui/pages/home/home_page.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().autoLogin(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading) {
      return const Scaffold(body: Loading());
    }

    if (auth.isLoggedIn) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}

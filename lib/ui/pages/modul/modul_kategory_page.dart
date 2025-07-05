import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';
import 'package:tugas_akhir/ui/widgets/modul_card.dart';

class ModulKategoriPage extends StatefulWidget {
  final int kategoriId;
  const ModulKategoriPage({super.key, required this.kategoriId});

  @override
  State<ModulKategoriPage> createState() => _ModulKategoriPageState();
}

class _ModulKategoriPageState extends State<ModulKategoriPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      context.read<ModulProvider>().fetchModulByKategoriId(
        authProvider.token,
        widget.kategoriId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modul")),
      body: Consumer<ModulProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Loading();
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.modulListByKategoriId.isEmpty) {
            return const Center(
              child: Text("Kategori ini belum ada Postingan."),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.modulListByKategoriId.length,
            itemBuilder: (context, index) {
              final modul = provider.modulListByKategoriId[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ModulCard(modul: modul),
              );
            },
          );
        },
      ),
    );
  }
}

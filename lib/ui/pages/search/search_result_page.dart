import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';
import 'package:tugas_akhir/ui/widgets/modul_card.dart';

class SearchResultPage extends StatelessWidget {
  final String searchQuery;
  const SearchResultPage({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hasil untuk: '$searchQuery'")),
      body: Consumer<ModulProvider>(
        builder: (context, provider, child) {
          if (provider.isSearching) {
            return const Loading();
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.searchResultList.isEmpty) {
            return const Center(child: Text("Modul tidak ditemukan."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.searchResultList.length,
            itemBuilder: (context, index) {
              final modul = provider.searchResultList[index];
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

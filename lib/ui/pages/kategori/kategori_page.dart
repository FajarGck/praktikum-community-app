import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/ui/widgets/input/standar_input.dart';
import 'package:tugas_akhir/ui/widgets/kategori_list.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  TextEditingController kategoriController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final kategori = context.watch<KategoriProvider>();
    final token = auth.token;
    final role = auth.authData?.user.role;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    if (role == 'admin')
                      Column(
                        children: [
                          StandarInput(
                            label: "Kategori",
                            controller: kategoriController,
                            hint: "Kategori Baru",
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (kategoriController.text.isEmpty) {
                                  return;
                                }
                                if (token == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Sesi tidak valid, silakan login ulang.",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                try {
                                  final bool isSuccess = await kategori
                                      .createKategori(
                                        token: token.toString(),
                                        kategoriName: kategoriController.text,
                                      );
                                  if (context.mounted) {
                                    if (isSuccess) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            kategori.successMessage ??
                                                "Kategori berhasil ditambahkan.",
                                          ),
                                        ),
                                      );
                                      kategoriController.clear();
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Tambah",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 12),
                KategoriList(provider: kategori, role: role.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

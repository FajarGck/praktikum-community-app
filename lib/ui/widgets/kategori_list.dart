import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/routes/app_routes.dart';
import 'package:tugas_akhir/ui/widgets/standar_input.dart';

class KategoriList extends StatelessWidget {
  const KategoriList({
    super.key,
    required this.provider,
    this.maxItems,
    this.role,
  });

  final KategoriProvider provider;
  final int? maxItems;
  final String? role;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final token = auth.token.toString();
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }
    if (provider.kategoriList.isEmpty) {
      return const Center(child: Text("Tidak ada kategori."));
    }
    final listToDisplay =
        maxItems != null
            ? provider.kategoriList.take(maxItems!).toList()
            : provider.kategoriList;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          listToDisplay.map((kategori) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.modulKategori,
                  arguments: kategori.kategoriId,
                );
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(kategori.namaKategori ?? 'Nama Kosong'),
                    ),
                    if (role == 'admin')
                      Positioned(
                        top: -10,
                        right: -5,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(10, 10),
                                  padding: EdgeInsets.all(0),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController _updateController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: Text(
                                          "Update data ${kategori.namaKategori}",
                                        ),
                                        content: StandarInput(
                                          label:
                                              kategori.namaKategori.toString(),
                                          controller: _updateController,
                                          hint: 'pemrogaman',
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("cancel"),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_updateController
                                                    .text
                                                    .isNotEmpty) {
                                                  provider.updateKategori(
                                                    token: token,
                                                    id:
                                                        kategori.kategoriId
                                                            .toString(),
                                                    kategoriName:
                                                        _updateController.text,
                                                  );
                                                }
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Kategori berhasil diubah.",
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(
                                                "Update",

                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 4),
                            // SizedBox(
                            //   height: 24,
                            //   width: 24,
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //       fixedSize: const Size(10, 10),
                            //       padding: EdgeInsets.all(0),
                            //     ),
                            //     onPressed: () {
                            //       deleteKategori(context, kategori, token);
                            //     },
                            //     child: Icon(Icons.delete, color: Colors.red),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Future<dynamic> deleteKategori(
    BuildContext context,
    KategoriModel kategori,
    String token,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            "Apakah Anda yakin ingin menghapus kategori '${kategori.namaKategori}'?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final isSuccess = await provider.deleteKategori(
                  id: kategori.kategoriId!.toString(),
                  token: token,
                );
                if (context.mounted) {
                  if (isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.errorMessage ?? "${provider.successMessage}",
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/routes/app_routes.dart';
import 'package:tugas_akhir/ui/widgets/komentar_card.dart';

class DetailModulPage extends StatefulWidget {
  final int modulId;
  const DetailModulPage({super.key, required this.modulId});

  @override
  State<DetailModulPage> createState() => _DetailModulPageState();
}

class _DetailModulPageState extends State<DetailModulPage> {
  final TextEditingController _komentarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengambil data detail modul saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<ModulProvider>(
        context,
        listen: false,
      ).fetchDetailModul(authProvider.token, widget.modulId);
    });
  }

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login untuk perbandingan ID
    final auth = context.read<AuthProvider>();
    final loggedInUserId = auth.authData?.user.userId;
    final token = auth.token!;

    return Scaffold(
      // === BAGIAN YANG DIUBAH ADA DI APPBAR INI ===
      appBar: AppBar(
        title: const Text("Detail Modul"),
        actions: [
          // Consumer ini akan me-render ulang tombol Edit saat data modul sudah siap
          Consumer<ModulProvider>(
            builder: (context, provider, child) {
              final modul = provider.detailModul;

              // Tampilkan tombol Edit HANYA jika:
              // 1. Data modul sudah ter-load (modul != null)
              // 2. ID user yang login SAMA DENGAN ID penulis modul
              if (modul != null && loggedInUserId == modul.penulis?.userId) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Modul',
                  onPressed: () {
                    // Navigasi ke halaman Edit, kirim seluruh data modul sebagai argumen
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editModul,
                      arguments: modul,
                    );
                  },
                );
              }
              // Jika kondisi tidak terpenuhi, jangan tampilkan apa-apa
              return const SizedBox.shrink();
            },
          ),
        ],
      ),

      //==============================================
      body: Consumer<ModulProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.detailModul == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null && provider.detailModul == null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final modul = provider.detailModul;
          if (modul != null) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (modul.thumbnailUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${ApiEndpoints.baseUrl}${modul.thumbnailUrl}",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  modul.judul ?? 'Tanpa Judul',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "${ApiEndpoints.baseUrl}${modul.penulis?.fotoProfil}",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modul.penulis?.username ?? 'Anonim',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Kategori: ${modul.kategori?.namaKategori ?? '-'}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                const Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(modul.deskripsi ?? 'Tidak ada deskripsi.'),
                const SizedBox(height: 24),
                const Text(
                  "Langkah-langkah Project",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (modul.langkah == null || modul.langkah!.isEmpty)
                  const Text("Tidak ada langkah-langkah yang tersedia.")
                else
                  Column(
                    children:
                        modul.langkah!.map((langkah) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${langkah.urutan}.",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(langkah.deskripsiLangkah ?? ''),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                const SizedBox(height: 24),
                Text(
                  "Komentar (${modul.komentar?.length ?? 0})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _komentarController,
                        decoration: InputDecoration(
                          hintText: "Tulis komentar...",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    if (provider.isKomentar)
                      const CircularProgressIndicator()
                    else
                      IconButton(
                        onPressed: () async {
                          if (_komentarController.text.isNotEmpty) {
                            final success = await provider.createKomentar(
                              token: token,
                              modulId: widget.modulId,
                              isiKomentar: _komentarController.text,
                            );
                            if (success) {
                              _komentarController.clear();
                            } else if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Gagal membuat komentar"),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                  ],
                ),
                SizedBox(height: 12),
                if (modul.komentar == null || modul.komentar!.isEmpty)
                  const Text("Belum ada Komentar")
                else
                  Column(
                    children:
                        modul.komentar!.map((komentar) {
                          return KomentarCard(komentar: komentar);
                        }).toList(),
                  ),
                SizedBox(height: 32),
              ],
            );
          }
          return const Center(child: Text("Modul tidak ditemukan."));
        },
      ),
    );
  }
}

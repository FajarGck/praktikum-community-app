import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/theme.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/provider/laporan_provider.dart';
import 'package:tugas_akhir/routes/app_routes.dart';

class LaporanAdminPage extends StatefulWidget {
  const LaporanAdminPage({super.key});

  @override
  State<LaporanAdminPage> createState() => _LaporanAdminPageState();
}

class _LaporanAdminPageState extends State<LaporanAdminPage> {
  @override
  void initState() {
    super.initState();
    // Ambil data laporan saat halaman dibuka
    Future.microtask(() =>
        Provider.of<LaporanProvider>(context, listen: false).fetchAllLaporan());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Masuk"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<LaporanProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.listLaporan.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined,
                      size: 80, color: Colors.green.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    "Bersih! Tidak ada laporan baru.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.listLaporan.length,
            itemBuilder: (context, index) {
              final item = provider.listLaporan[index];
              
              // Data Pelapor
              final pelapor = item['pelapor']?['username'] ?? 'Anonim';
              
              // Data Modul & Penulis
              final modulData = item['modul'];
              final judulModul = modulData?['judul'] ?? 'Modul Terhapus';
              final modulId = modulData?['modul_id'];
              
              // Data Penulis (Target Sanksi)
              final penulisData = modulData?['penulis'];
              final String penulisName = penulisData?['username'] ?? 'Unknown';
              final int? penulisId = penulisData?['user_id'];
              final bool isSanctioned = penulisData?['can_upload'] == false;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER: Status & Kategori ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.redAccent),
                            ),
                            child: Text(
                              item['kategori']
                                  .toString()
                                  .toUpperCase()
                                  .replaceAll('_', ' '),
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "Pelapor: $pelapor",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // --- CONTENT: Info Modul ---
                      Text(
                        judulModul,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Penulis: $penulisName ${isSanctioned ? '(DIBATASI)' : ''}",
                        style: TextStyle(
                          fontSize: 12,
                          color: isSanctioned ? Colors.red : Colors.black87,
                          fontWeight:
                              isSanctioned ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "\"${item['deskripsi']}\"",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const Divider(height: 24),

                      // --- FOOTER: Action Buttons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 1. LIHAT MODUL
                          if (modulId != null)
                            IconButton(
                              tooltip: "Lihat Detail Modul",
                              icon: const Icon(Icons.visibility, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.detailModul,
                                    arguments: modulId);
                              },
                            ),

                          // 2. SANKSI USER (Toggle)
                          if (penulisId != null)
                            IconButton(
                              tooltip: isSanctioned
                                  ? "Cabut Sanksi"
                                  : "Berikan Sanksi Upload",
                              icon: Icon(
                                isSanctioned
                                    ? Icons.lock_open_rounded
                                    : Icons.block_rounded,
                                color: isSanctioned
                                    ? Colors.green
                                    : Colors.orangeAccent,
                              ),
                              onPressed: () async {
                                final authorProv = Provider.of<AuthorProvider>(
                                    context,
                                    listen: false);
                                
                                bool success = await authorProv.toggleSanction(
                                    token!, penulisId);

                                if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isSanctioned
                                          ? "Sanksi dicabut. User bisa upload lagi."
                                          : "User berhasil disanksi (Disable Upload)."),
                                      backgroundColor: isSanctioned
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  );
                                  // Refresh data laporan agar status UI berubah
                                  provider.fetchAllLaporan();
                                }
                              },
                            ),

                          const SizedBox(width: 8),

                          // 3. SELESAI (Hapus Laporan)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text("Selesai"),
                            onPressed: () {
                              _showDeleteConfirm(context, provider, item['laporan_id']);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirm(
      BuildContext context, LaporanProvider provider, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tandai Selesai?"),
        content: const Text(
            "Laporan akan dihapus dari daftar. Pastikan Anda sudah mengambil tindakan yang diperlukan."),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(ctx);
              provider.hapusLaporan(id);
            },
            child: const Text("Ya, Selesai"),
          ),
        ],
      ),
    );
  }
}
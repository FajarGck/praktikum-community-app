import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/report_provider.dart';
import 'package:tugas_akhir/routes/app_routes.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshReports();
    });
  }

  Future<void> _refreshReports() async {
    final auth = context.read<AuthProvider>();
    if (auth.token != null) {
      await context.read<ReportProvider>().fetchPendingReports(
            token: auth.token!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final token = auth.token;

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Masuk')),
      body: Consumer<ReportProvider>(
        builder: (context, rp, child) {
          if (rp.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (rp.errorMessage != null && rp.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rp.errorMessage!),
                  ElevatedButton(
                    onPressed: _refreshReports,
                    child: const Text("Coba Lagi"),
                  )
                ],
              ),
            );
          }
          if (rp.reports.isEmpty) {
            return const Center(child: Text('Tidak ada laporan pending.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshReports,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: rp.reports.length,
              itemBuilder: (context, i) {
                final report = rp.reports[i];
                final modul = report.modul;
                final modulId = modul?.modulId;
                
                // Ambil status modul untuk logika tombol
                final currentStatus = modul?.status ?? 'pending';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER: Judul & Badge Status ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                modul?.judul ?? 'Modul Tidak Ditemukan',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _statusBadge(currentStatus),
                          ],
                        ),
                        const Divider(height: 24),

                        // --- BODY: Informasi Pelapor ---
                        _infoRow(Icons.person, 'Pelapor',
                            report.reporter?.username ?? 'Anonim'),
                        const SizedBox(height: 8),
                        _infoRow(Icons.warning_amber_rounded, 'Alasan',
                            report.reason ?? '-'),
                        if (report.note != null && report.note!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _infoRow(Icons.note, 'Catatan', report.note!),
                        ],

                        const SizedBox(height: 16),

                        // --- FOOTER: Tombol Aksi ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Tombol Lihat Isi Modul
                            OutlinedButton.icon(
                              onPressed: modulId == null
                                  ? null
                                  : () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.detailModul,
                                        arguments: modulId,
                                      ),
                              icon: const Icon(Icons.visibility, size: 18),
                              label: const Text('Cek Modul'),
                            ),
                            const SizedBox(width: 8),

                            // Tombol Admin (Hanya jika user adalah admin)
                            if (auth.authData?.user.role == 'admin')
                              FilledButton.icon(
                                icon: const Icon(Icons.admin_panel_settings,
                                    size: 18),
                                label: const Text('Tindak'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                ),
                                onPressed: (modulId == null || token == null)
                                    ? null
                                    : () => _showActionSheet(
                                          context,
                                          rp,
                                          token,
                                          modulId,
                                          currentStatus,
                                        ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER: Tampilan Baris Info ---
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text('$label:',
              style: TextStyle(color: Colors.grey[800], fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ),
      ],
    );
  }

  // --- LOGIKA UTAMA: Menu Tindakan Admin ---
  void _showActionSheet(BuildContext context, ReportProvider rp, String token,
      int modulId, String currentStatus) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Tindakan untuk Modul #$modulId',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                // --- OPSI 1: Logika HIDE / UNHIDE ---
                if (currentStatus == 'suspended')
                  // Jika sedang disembunyikan -> Tampilkan tombol PULIHKAN
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      child: const Icon(Icons.visibility, color: Colors.green),
                    ),
                    title: const Text('Pulihkan (Unhide/Approve)'),
                    subtitle: const Text(
                        'Masalah selesai? Tampilkan kembali modul ini.'),
                    onTap: () async {
                      Navigator.pop(context);
                      _processAction(
                        context,
                        rp,
                        token,
                        modulId,
                        'approved', // Status baru
                        'Modul berhasil dipulihkan (Tayang Kembali)',
                      );
                    },
                  )
                else
                  // Jika sedang tayang/pending -> Tampilkan tombol SEMBUNYIKAN
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.withOpacity(0.1),
                      child: const Icon(Icons.visibility_off,
                          color: Colors.orange),
                    ),
                    title: const Text('Sembunyikan (Suspend)'),
                    subtitle: const Text(
                        'Amankan sementara agar user memperbaikinya.'),
                    onTap: () async {
                      Navigator.pop(context);
                      _processAction(
                        context,
                        rp,
                        token,
                        modulId,
                        'suspended', // Status baru
                        'Modul berhasil disembunyikan (Suspended)',
                      );
                    },
                  ),

                const Divider(),

                // --- OPSI 2: Logika HAPUS PERMANEN (Selalu Ada) ---
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    child: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                  title: const Text('Hapus Permanen (Ban)'),
                  subtitle:
                      const Text('Pelanggaran berat. Hapus & tutup laporan.'),
                  onTap: () async {
                    Navigator.pop(context);
                    _confirmDelete(context, rp, token, modulId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- HELPER: Dialog Konfirmasi Hapus ---
  void _confirmDelete(
      BuildContext context, ReportProvider rp, String token, int modulId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
            'Apakah Anda yakin ingin mem-banned modul ini?\n\nTindakan ini permanen dan laporan akan otomatis ditandai selesai.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _processAction(
                context,
                rp,
                token,
                modulId,
                'banned', // Status baru
                'Modul berhasil dihapus permanen (Banned)',
              );
            },
            child: const Text('Hapus (Ban)'),
          ),
        ],
      ),
    );
  }

  // --- HELPER: Proses Eksekusi ke Provider ---
  Future<void> _processAction(BuildContext context, ReportProvider rp,
      String token, int modulId, String newStatus, String successMessage) async {
    // Panggil fungsi generic di ReportProvider
    final success = await rp.updateModulStatus(
      token: token,
      modulId: modulId,
      status: newStatus,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );
        _refreshReports(); // Refresh list agar status terupdate
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(rp.errorMessage ?? 'Gagal memproses tindakan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- HELPER: Badge Status Warna-warni ---
  Widget _statusBadge(String statusRaw) {
    final status = statusRaw.toLowerCase();
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'approved':
        color = Colors.green;
        label = 'Tayang';
        icon = Icons.check_circle;
        break;
      case 'suspended':
        color = Colors.orange;
        label = 'Suspended';
        icon = Icons.warning;
        break;
      case 'banned':
        color = Colors.red;
        label = 'Banned';
        icon = Icons.block;
        break;
      case 'pending':
        color = Colors.blue;
        label = 'Pending';
        icon = Icons.hourglass_empty;
        break;
      case 'reject':
        color = Colors.redAccent;
        label = 'Ditolak';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        label = status.toUpperCase();
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
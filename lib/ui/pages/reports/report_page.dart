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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      await context.read<ReportProvider>().fetchPendingReports(
        token: auth.token!,
      );
    });
  }

  Future<void> _refreshReports() async {
    final auth = context.read<AuthProvider>();
    await context.read<ReportProvider>().fetchPendingReports(
      token: auth.token!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final token = auth.token!;

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: Consumer<ReportProvider>(
        builder: (context, rp, child) {
          if (rp.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (rp.errorMessage != null && rp.reports.isEmpty) {
            return Center(child: Text(rp.errorMessage!));
          }
          if (rp.reports.isEmpty) {
            return const Center(child: Text('Belum ada laporan.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshReports,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: rp.reports.length,
              itemBuilder: (context, i) {
                final r = rp.reports[i];
                final modul = r.modul;
                final modulId = modul?.modulId;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                modul?.judul ?? 'Modul tidak diketahui',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _statusBadge(modul?.status ?? 'unknown'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Pelapor: ${r.reporter?.username ?? '-'}'),
                        Text('Alasan: ${r.reason}'),
                        if (r.note != null && r.note!.isNotEmpty)
                          Text('Catatan: ${r.note}'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            TextButton(
                              onPressed:
                                  modulId == null
                                      ? null
                                      : () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.detailModul,
                                          arguments: modulId,
                                        );
                                      },
                              child: const Text('Lihat'),
                            ),
                            const Spacer(),
                            if (auth.authData?.user.role == 'admin')
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed:
                                    modulId == null
                                        ? null
                                        : () async {
                                          final action = await showModalBottomSheet<
                                            String
                                          >(
                                            context: context,
                                            showDragHandle:
                                                true, // butuh Flutter versi baru, kalau error hapus saja
                                            builder: (sheetContext) {
                                              return SafeArea(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.visibility_off,
                                                      ),
                                                      title: const Text(
                                                        'Hide (Reject)',
                                                      ),
                                                      onTap:
                                                          () => Navigator.pop(
                                                            sheetContext,
                                                            'hide',
                                                          ),
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      title: const Text('Delete'),
                                                      textColor: Colors.red,
                                                      iconColor: Colors.red,
                                                      onTap:
                                                          () => Navigator.pop(
                                                            sheetContext,
                                                            'delete',
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );

                                          if (action == null) return;

                                          if (action == 'hide') {
                                            final ok = await rp.hideModul(
                                              token: token,
                                              modulId: modulId,
                                            );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  ok
                                                      ? 'Modul di-hide (reject)'
                                                      : (rp.errorMessage ??
                                                          'Gagal'),
                                                ),
                                              ),
                                            );
                                            if (ok) await _refreshReports();
                                          }

                                          if (action == 'delete') {
                                            final confirm = await showDialog<
                                              bool
                                            >(
                                              context: context,
                                              builder:
                                                  (ctx) => AlertDialog(
                                                    title: const Text(
                                                      'Hapus modul?',
                                                    ),
                                                    content: const Text(
                                                      'Tindakan ini permanen dan tidak bisa dibatalkan.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              ctx,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          'Batal',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              ctx,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'Hapus',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                            if (confirm != true) return;

                                            final ok = await rp
                                                .deleteModulAsAdmin(
                                                  token: token,
                                                  modulId: modulId,
                                                );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  ok
                                                      ? 'Modul dihapus permanen'
                                                      : (rp.errorMessage ??
                                                          'Gagal'),
                                                ),
                                              ),
                                            );
                                            if (ok) await _refreshReports();
                                          }
                                        },
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
}

Widget _statusBadge(String statusRaw) {
  final status = statusRaw.toLowerCase();
  Color bg;
  String label;

  switch (status) {
    case 'reject':
      bg = Colors.red;
      label = 'REJECTED';
      break;
    case 'pending':
      bg = Colors.orange;
      label = 'PENDING';
      break;
    default:
      bg = Colors.grey;
      label = status.toUpperCase();
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bg.withOpacity(0.15),
      border: Border.all(color: bg),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(color: bg, fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );
}

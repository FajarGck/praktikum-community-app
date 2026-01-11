import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/report_model.dart';
import 'package:tugas_akhir/routes/app_routes.dart';

class ReportList extends StatelessWidget {
  final List<ReportModel> listReport;
  final int? maxItems;
  final Axis direction;

  const ReportList({
    super.key,
    required this.listReport,
    this.maxItems,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = (maxItems == null)
        ? listReport.length
        : maxItems!.clamp(0, listReport.length);

    if (itemCount == 0) return const SizedBox.shrink();
    if (direction == Axis.vertical) {
      return Column(
        children: List.generate(itemCount, (i) {
          final r = listReport[i];
          return _UserReportCard(report: r);
        }),
      );
    }
    return SizedBox(
      height: 242,
      child: ListView.separated(
        scrollDirection: direction,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => SizedBox(
          width: 350,
          child: _UserReportCard(report: listReport[i]),
        ),
      ),
    );
  }
}

class _UserReportCard extends StatelessWidget {
  final ReportModel report;
  const _UserReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final modul = report.modul;
    final modulId = modul?.modulId;

    final reportStatus = (report.status).toLowerCase();
    final modulStatus = (modul?.status ?? '').toLowerCase();

    final updateText = _buildUserUpdateText(
      reportStatus: reportStatus,
      modulIsNull: modul == null,
      modulStatus: modulStatus,
    );

    final updateIcon = _buildUserUpdateIcon(
      reportStatus: reportStatus,
      modulIsNull: modul == null,
      modulStatus: modulStatus,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: modulId == null
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.detailModul,
                  arguments: modulId,
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      modul?.judul ?? 'Modul sudah tidak tersedia',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _reportStatusBadge(report.status),
                ],
              ),

              const SizedBox(height: 8),
              Text('Alasan: ${report.reason}'),
              if ((report.note ?? '').trim().isNotEmpty)
                Text('Catatan: ${report.note}'),

              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Icon(updateIcon, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        updateText,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              if (report.createdAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Dibuat: ${report.createdAt!.toLocal().toString().split(".").first}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: modulId == null
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detailModul,
                            arguments: modulId,
                          );
                        },
                  child: Text(modulId == null ? 'Modul tidak tersedia' : 'Lihat modul'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _reportStatusBadge(String statusRaw) {
  final s = statusRaw.toLowerCase();
  Color c;
  String label;

  switch (s) {
    case 'resolved':
      c = Colors.green;
      label = 'Selesai';
      break;
    case 'pending':
      c = Colors.orange;
      label = 'Menunggu';
      break;
    case 'rejected':
      c = Colors.red;
      label = 'Ditolak';
      break;
    default:
      c = Colors.grey;
      label = s.toUpperCase();
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: c.withOpacity(0.12),
      border: Border.all(color: c),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 12),
    ),
  );
}

String _buildUserUpdateText({
  required String reportStatus,
  required bool modulIsNull,
  required String modulStatus,
}) {
  if (modulIsNull) {
    return 'Update: Modul kemungkinan sudah dihapus.';
  }

  if (modulStatus == 'reject' || modulStatus == 'hidden' || modulStatus == 'inactive') {
    return 'Update: Modul disembunyikan oleh admin.';
  }

  if (reportStatus == 'pending') {
    return 'Update: Menunggu ditinjau admin.';
  }

  if (reportStatus == 'resolved') {
    return 'Update: Ditinjau admin (tidak ada tindakan pada modul).';
  }

  if (reportStatus == 'rejected') {
    return 'Update: Laporan ditolak admin.';
  }

  return 'Update: Status belum diketahui.';
}

IconData _buildUserUpdateIcon({
  required String reportStatus,
  required bool modulIsNull,
  required String modulStatus,
}) {
  if (modulIsNull) return Icons.delete_forever;

  if (modulStatus == 'reject' || modulStatus == 'hidden' || modulStatus == 'inactive') {
    return Icons.visibility_off;
  }

  if (reportStatus == 'pending') return Icons.hourglass_top;
  if (reportStatus == 'resolved') return Icons.check_circle;
  if (reportStatus == 'rejected') return Icons.cancel;

  return Icons.info_outline;
}

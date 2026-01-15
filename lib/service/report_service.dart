import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/report_model.dart';

class ReportService {
  Future<Map<String, dynamic>> createReport({
    required String token,
    required int modulId,
    required String reason,
    String? note,
  }) async {
    final uri = Uri.parse(ApiEndpoints.report);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'modul_id': modulId, 'reason': reason, 'note': note}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) return data;
    throw Exception(data['message'] ?? 'Gagal mengirim report');
  }

  // Khusus Admin: Mengambil SEMUA laporan
  Future<List<ReportModel>> getPendingReports({required String token}) async {
    final uri = Uri.parse(ApiEndpoints.report);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final List list = (data['data'] ?? []) as List;
      return list.map((e) => ReportModel.fromJson(e)).toList();
    }
    throw Exception(data['message'] ?? 'Gagal mengambil laporan');
  }

  // BARU: Khusus User Biasa: Mengambil laporan milik user sendiri
  Future<List<ReportModel>> getUserReports({
    required String token,
    required int userId,
  }) async {
    // Memanggil endpoint: GET /report/:userId
    final uri = Uri.parse('${ApiEndpoints.report}/$userId');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final List list = (data['data'] ?? []) as List;
      return list.map((e) => ReportModel.fromJson(e)).toList();
    }
    throw Exception(data['message'] ?? 'Gagal mengambil riwayat laporan');
  }

  Future<void> resolveReport({
    required String token,
    required int reportId,
  }) async {
    final uri = Uri.parse(ApiEndpoints.resolveReport(reportId));
    final response = await http.patch(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) return;
    throw Exception(data['message'] ?? 'Gagal resolve report');
  }

  Future<void> updateModulStatus({
    required String token,
    required int modulId,
    required String status,
  }) async {
    final uri = Uri.parse(ApiEndpoints.updateModulStatus(modulId));
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) return;
    throw Exception(data['message'] ?? 'Gagal update status modul');
  }

  Future<void> adminDeleteModul({
    required String token,
    required int modulId,
  }) async {
    final uri = Uri.parse(ApiEndpoints.adminDeleteModul(modulId));
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) return;
    throw Exception(data['message'] ?? 'Gagal menghapus modul');
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api.dart';

class LaporanService {
  final storage = const FlutterSecureStorage();

  // 1. KIRIM LAPORAN (User)
  Future<bool> kirimLaporan({
    required int modulId,
    required String kategori,
    required String deskripsi,
  }) async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      if (token == null) return false;

      var url = Uri.parse(ApiEndpoints.laporan);

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'modul_id': modulId,
          'kategori': kategori,
          'deskripsi': deskripsi,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error kirim laporan: $e');
      return false;
    }
  }

  // 2. [BARU] AMBIL SEMUA LAPORAN (Admin)
  Future<List<dynamic>> getAllLaporan() async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      // Pastikan endpoint ini benar (GET /laporan)
      var url = Uri.parse(ApiEndpoints.laporan); 

      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Mengembalikan list data laporan
        return data['data'] ?? []; 
      }
      return [];
    } catch (e) {
      print('Error get all laporan: $e');
      return [];
    }
  }

  // 3. [BARU] HAPUS LAPORAN (Admin)
  Future<bool> deleteLaporan(int laporanId) async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      // Endpoint: DELETE /laporan/:id
      var url = Uri.parse('${ApiEndpoints.laporan}/$laporanId');

      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error delete laporan: $e');
      return false;
    }
  }
}
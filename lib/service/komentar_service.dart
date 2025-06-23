import 'dart:convert';

import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/komentar_model.dart';
import 'package:http/http.dart' as http;

class KomentarService {
  Future<KomentarModel> createKomentar({
    required String token,
    required int modulId,
    required String isiKomentar,
    int? parentId,
  }) async {
    final uri = Uri.parse(ApiEndpoints.createKomentar);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'modul_id': modulId,
        'isi_komentar': isiKomentar,
        'parentId': parentId,
      }),
    );

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 201) {
      return KomentarModel.fromJson(responseData['data']);
    } else {
      throw Exception(responseData['message']);
    }
  }
}

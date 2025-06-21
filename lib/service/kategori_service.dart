import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/kategori_model.dart';

class KategoriService {
  Future<List<KategoriModel>> listKategori(String? token) async {
    final uri = Uri.parse(ApiEndpoints.kategori);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      List<dynamic> data = responseData['data'];
      List<KategoriModel> kategoriList =
          data.map((item) => KategoriModel.fromJson(item)).toList();
      return kategoriList;
    } else {
      throw Exception(responseData['message']);
    }
  }

  Future<String> createKategori(String? token, String name) async {
    final uri = Uri.parse(ApiEndpoints.kategori);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nama_kategori': name}),
    );
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      final message = responseData['message'];
      return message;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal Memuat Kategori');
    }
  }

  Future<String> deleteKategori(String? token, String id) async {
    final uri = Uri.parse('${ApiEndpoints.kategori}/$id');
    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData =
        await jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final message = responseData['message'];
      return message;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal Menghapus Kategori');
    }
  }
}

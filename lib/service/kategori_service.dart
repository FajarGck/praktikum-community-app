import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';

class KategoriService {
  Future<List<KategoriModel>> listKategori() async {
    final token = await AuthProvider().init();
    final uri = Uri.parse(ApiEndpoints.getAllKategori);
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
      // Ubah setiap item di list menjadi KategoriModel menggunakan fromJson
      List<KategoriModel> kategoriList =
          data.map((item) => KategoriModel.fromJson(item)).toList();
      print(data);
      return kategoriList;
    } else {
      throw Exception(responseData['message']);
    }
  }
}

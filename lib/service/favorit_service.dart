import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/modul_model.dart';

class FavoritService {
  Future<Map<String, dynamic>> toggleFavorit(String token, int modulId) async {
    final uri = Uri.parse(ApiEndpoints.toggleFavorit(modulId));
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message']);
    }
  }

  Future<List<ModulModel>> getFavorit(String token) async {
    final uri = Uri.parse(ApiEndpoints.favorit);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      List<dynamic> data = responseData['data'];
      return data.map((item) {
        final modul = ModulModel.fromJson(item);
        modul.isFavorit = true;
        return modul;
      }).toList();
    } else {
      throw Exception(responseData['message']);
    }
  }

  Future<bool> checkIsFavorited(String token, int modulId) async {
    final uri = Uri.parse(ApiEndpoints.checkFavoritStatus(modulId));
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isFavorited'];
    } else {
      throw Exception('Gagal memeriksa status favorit');
    }
  }
}

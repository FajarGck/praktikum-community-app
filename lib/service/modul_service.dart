import 'dart:convert';

import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:http/http.dart' as http;

class ModulService {
  Future<List<ModulModel>> listModul(String? token) async {
    final uri = Uri.parse(ApiEndpoints.getAllModul);
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
      List<ModulModel> modulList =
          data.map((item) => ModulModel.fromJson(item)).toList();
      return modulList;
    } else {
      throw Exception(responseData['message'] ?? 'gagal');
    }
  }

  Future<List<ModulModel>> listModulById(String? token, int userId) async {
    final uri = Uri.parse(ApiEndpoints.getCardModulByUserId(userId));
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
      List<ModulModel> modulList =
          data.map((item) => ModulModel.fromJson(item)).toList();
      return modulList;
    } else {
      throw Exception(responseData['message'] ?? 'gagal');
    }
  }

  Future<ModulModel> getDetailModul(String? token, int id) async {
    final uri = Uri.parse(ApiEndpoints.getDetailModulById(id));
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return ModulModel.fromJson(responseData['data']);
    } else {
      throw Exception(responseData['message'] ?? 'gagal');
    }
  }

  Future<List<ModulModel>> searchModul(String? token, String query) async {
    final uri = Uri.parse(ApiEndpoints.searchModul(query));
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
      List<ModulModel> modulList =
          data.map((item) => ModulModel.fromJson(item)).toList();
      return modulList;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal mencari modul');
    }
  }
}

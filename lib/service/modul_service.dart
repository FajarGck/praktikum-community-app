import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/modul_model.dart';

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

  Future<List<ModulModel>> listModulByUserId(String? token, int userId) async {
    final uri = Uri.parse(ApiEndpoints.getCardModulByUserId(userId));
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responsedata = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      List<dynamic> data = responsedata['data'];
      List<ModulModel> modulList =
          data.map((item) => ModulModel.fromJson(item)).toList();
      return modulList;
    } else {
      throw Exception(responsedata['message'] ?? 'gagal');
    }
  }

  Future<List<ModulModel>> listModulByKategoriId(
    String? token,
    int kategoriId,
  ) async {
    final uri = Uri.parse(ApiEndpoints.getCardModulByKategoriId(kategoriId));
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

  Future<ModulModel> createModul({
    required String token,
    required String judul,
    required String deskripsi,
    required int kategoriId,
    required File thumbnailImage,
    required List<Map<String, dynamic>> langkah,
  }) async {
    final uri = Uri.parse(ApiEndpoints.getAllModul);
    final request = http.MultipartRequest('POST', uri);

    final mimeTypeData = lookupMimeType(
      thumbnailImage.path,
      headerBytes: [0xFF, 0xD8],
    )?.split('/');

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['judul'] = judul;
    request.fields['deskripsi'] = deskripsi;
    request.fields['kategori_id'] = kategoriId.toString();
    request.fields['langkah'] = jsonEncode(langkah);

    request.files.add(
      await http.MultipartFile.fromPath(
        'thumbnail_url',
        thumbnailImage.path,
        contentType:
            mimeTypeData != null
                ? MediaType(mimeTypeData[0], mimeTypeData[1])
                : null,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      return ModulModel.fromJson(responseData['data']);
    } else {
      throw Exception(responseData['message'] ?? 'Gagal membuat modul');
    }
  }

  Future<ModulModel> updateModul({
    required String token,
    required int modulId,
    required String judul,
    required String deskripsi,
    required int kategoriId,
    File? thumbnailImage,
    required List<Map<String, dynamic>> langkah,
  }) async {
    final uri = Uri.parse(ApiEndpoints.getDetailModulById(modulId));
    final request = http.MultipartRequest('PATCH', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['judul'] = judul;
    request.fields['deskripsi'] = deskripsi;
    request.fields['kategori_id'] = kategoriId.toString();
    request.fields['langkah'] = jsonEncode(langkah);

    if (thumbnailImage != null) {
      final mimeTypeData = lookupMimeType(
        thumbnailImage.path,
        headerBytes: [0xFF, 0xD8],
      )?.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail_url',
          thumbnailImage.path,
          contentType:
              mimeTypeData != null
                  ? MediaType(mimeTypeData[0], mimeTypeData[1])
                  : null,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return ModulModel.fromJson(responseData['data']);
    } else {
      throw Exception(responseData['message'] ?? 'Gagal memperbarui modul');
    }
  }
}

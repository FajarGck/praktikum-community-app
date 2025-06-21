import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/models/auth_response.dart';
import 'package:tugas_akhir/models/user_model.dart';
import '../config/api.dart';

class AuthService {
  Future<UsersModel> register({
    required String username,
    required String password,
    required String email,
  }) async {
    final uri = Uri.parse(ApiEndpoints.register);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = responseData['data'];
      return UsersModel.fromJson(data);
    } else {
      final message = responseData['message'];
      throw message;
    }
  }

  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse(ApiEndpoints.login);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = responseData['data'];
      if (data == null) {
        return AuthResponse.fromJson(responseData['message']);
      }

      return AuthResponse.fromJson(data as Map<String, dynamic>);
    } else {
      final message = responseData['message'];
      throw message;
    }
  }

  Future<UsersModel> getUserProfile(String token) async {
    final uri = Uri.parse(ApiEndpoints.me);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print("✅ Profil berhasil dimuat: $data");
      return UsersModel.fromJson(data);
    } else {
      final responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'] ?? 'Gagal memuat profil';
      throw Exception('Error $errorMessage - Status: ${response.statusCode}');
    }
  }
}

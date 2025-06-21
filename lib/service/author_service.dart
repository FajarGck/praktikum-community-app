import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/user_model.dart';

class AuthorService {
  Future<List<UsersModel>> listAuthor(String token) async {
    final uri = Uri.parse(ApiEndpoints.getAllAuthor);
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
      List<UsersModel> authorList =
          data.map((item) => UsersModel.fromJson(item)).toList();
      return authorList;
    } else {
      throw Exception(responseData['message']);
    }
  }

  Future<String> createAdmin({
    required String token,
    required String username,
    required String password,
    required String email,
    required String role,
  }) async {
    final uri = Uri.parse(ApiEndpoints.createAdmin);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'role': role,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      final data = responseData['message'] as String;
      return data;
    } else {
      final message = responseData['message'];
      throw message;
    }
  }
}

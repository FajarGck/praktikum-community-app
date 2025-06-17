import 'package:tugas_akhir/models/user_model.dart';

class AuthResponse {
  final String token;
  final UsersModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: UsersModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/user_model.dart';

class AuthorsBox extends StatelessWidget {
  final VoidCallback? onTap;
  final UsersModel author;

  const AuthorsBox({super.key, required this.author, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "${ApiEndpoints.baseUrl}${author.fotoProfil}";
    String username = author.username ?? 'No Name';
    if (username.length > 8) {
      username = '${username.substring(0, 8)}...';
    }
    return GestureDetector(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFD9D9D9),
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 4),
          Text(username, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

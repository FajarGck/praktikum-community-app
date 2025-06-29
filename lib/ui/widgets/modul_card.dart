import 'package:flutter/material.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/routes/app_routes.dart';

class ModulCard extends StatelessWidget {
  final ModulModel modul;
  const ModulCard({super.key, required this.modul});

  @override
  Widget build(BuildContext context) {
    final profileUrl = "${ApiEndpoints.baseUrl}${modul.penulis?.fotoProfil}";
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            AppRoutes.detailModul,
            arguments: modul.modulId,
          ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                modul.judul!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                modul.deskripsi!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(profileUrl)),
                  const SizedBox(width: 4),
                  Text(
                    modul.penulis?.username ?? "no name",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

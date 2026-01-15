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
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.detailModul,
        arguments: modul.modulId,
      ),
      child: SizedBox(
        width: 300,
        height: 300, // tetap pakai tinggi card
        child: Container(
          // sedikit kurangi padding bawah untuk berjaga-jaga
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (modul.status == 'reject')
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.block_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Modul telah dibanned karena melanggar ketentuan.",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              if (modul.status == 'suspended')
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.yellow[400],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility_off_sharp, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Modul telah disembunyikan karena melanggar ketentuan.",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // ===== gunakan Flexible supaya tidak memaksa ruang berlebih =====
              Flexible(
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
                    const SizedBox(height: 4),
                    Text(
                      modul.deskripsi!,
                      // kembalikan ke 2 baris (atau 1-2) agar aman pada tinggi 300
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6), // dikurangi sedikit dari 8

              Row(
                children: [
                  // sedikit perkecil radius jika masih mepet
                  CircleAvatar(radius: 12, backgroundImage: NetworkImage(profileUrl)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      modul.penulis?.username ?? "no name",
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
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

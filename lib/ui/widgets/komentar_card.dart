import 'package:flutter/material.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/komentar_model.dart';

class KomentarCard extends StatelessWidget {
  final KomentarModel komentar;
  const KomentarCard({super.key, required this.komentar});

  @override
  Widget build(BuildContext context) {
    final penulisImage =
        "${ApiEndpoints.baseUrl}${komentar.penulis?.fotoProfil}";
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(penulisImage),
                ),
                Text(komentar.penulis?.username ?? 'Anonymus'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              komentar.isiKomentar ?? "empty",

              style: TextStyle(fontSize: 10),
            ),
            // Text(provider.detailModul?.komentar?[0],is),
          ],
        ),
      ),
    );
  }
}

// lib/models/komentar_model.dart

import 'package:tugas_akhir/models/user_model.dart'; // Impor model user

class KomentarModel {
  int? komentarId;
  int? modulId;
  int? userId;
  String? isiKomentar;
  int? parentId;
  DateTime? createdAt;
  UsersModel? penulis;

  KomentarModel({
    this.komentarId,
    this.modulId,
    this.userId,
    this.isiKomentar,
    this.parentId,
    this.createdAt,
    this.penulis,
  });

  factory KomentarModel.fromJson(Map<String, dynamic> json) {
    return KomentarModel(
      komentarId: json['komentar_id'],
      modulId: json['modul_id'],
      userId: json['user_id'],
      isiKomentar: json['isi_komentar'],
      parentId: json['parent_id'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      // Parse data penulis jika ada
      penulis:
          json['penulis'] != null
              ? UsersModel.fromJson(json['penulis'])
              : null, // <-- TAMBAHKAN INI
    );
  }
}

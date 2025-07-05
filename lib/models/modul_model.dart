import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/models/komentar_model.dart';
import 'package:tugas_akhir/models/langkah_model.dart';
import 'package:tugas_akhir/models/user_model.dart';

class ModulModel {
  int? modulId;
  String? judul;
  String? thumbnailUrl;
  String? deskripsi;
  int? kategoriId;
  int? penulisId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  UsersModel? penulis;
  KategoriModel? kategori;
  List<KomentarModel>? komentar;
  List<LangkahModel>? langkah;
  bool isFavorit;

  ModulModel({
    this.modulId,
    this.judul,
    this.thumbnailUrl,
    this.deskripsi,
    this.kategoriId,
    this.penulisId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.penulis,
    this.kategori,
    this.komentar,
    this.langkah,
    this.isFavorit = false,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      modulId: json['modul_id'],
      judul: json['judul'],
      thumbnailUrl: json['thumbnail_url'],
      deskripsi: json['deskripsi'],
      kategoriId: json['kategori_id'],
      penulisId: json['penulis_id'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      status: json['status'],
      penulis:
          json['penulis'] != null ? UsersModel.fromJson(json['penulis']) : null,
      kategori:
          json['kategori'] != null
              ? KategoriModel.fromJson(json['kategori'])
              : null,
      komentar:
          json['komentar'] != null
              ? List<KomentarModel>.from(
                json['komentar'].map((x) => KomentarModel.fromJson(x)),
              )
              : [],
      langkah:
          json['langkah'] != null
              ? List<LangkahModel>.from(
                json['langkah'].map((x) => LangkahModel.fromJson(x)),
              )
              : [],
      isFavorit: json['is_favorit'] ?? false,
    );
  }
}

class KategoriModel {
  int? kategoriId;
  String? namaKategori;

  KategoriModel({this.kategoriId, this.namaKategori});

  KategoriModel.fromJson(Map<String, dynamic> json) {
    kategoriId = json['kategori_id'];
    namaKategori = json['nama_kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kategori_id'] = kategoriId;
    data['nama_kategori'] = namaKategori;
    return data;
  }
}

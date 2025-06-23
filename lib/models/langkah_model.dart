class LangkahModel {
  int? langkahId;
  int? modulId;
  int? urutan;
  String? deskripsiLangkah;
  Null? fotoLangkah;

  LangkahModel({
    this.langkahId,
    this.modulId,
    this.urutan,
    this.deskripsiLangkah,
    this.fotoLangkah,
  });

  LangkahModel.fromJson(Map<String, dynamic> json) {
    langkahId = json['langkah_id'];
    modulId = json['modul_id'];
    urutan = json['urutan'];
    deskripsiLangkah = json['deskripsi_langkah'];
    fotoLangkah = json['foto_langkah'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['langkah_id'] = langkahId;
    data['modul_id'] = modulId;
    data['urutan'] = urutan;
    data['deskripsi_langkah'] = deskripsiLangkah;
    data['foto_langkah'] = fotoLangkah;
    return data;
  }
}

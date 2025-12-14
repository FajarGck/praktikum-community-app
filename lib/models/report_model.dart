class ReportModel {
  final int reportId;
  final String reason;
  final String status;
  final String? note;
  final DateTime? createdAt;

  final ReporterModel? reporter;
  final ReportedModulModel? modul;

  ReportModel({
    required this.reportId,
    required this.reason,
    required this.status,
    this.note,
    this.createdAt,
    this.reporter,
    this.modul,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['report_id'],
      reason: json['reason']?.toString() ?? '-',
      status: json['status']?.toString() ?? 'pending',
      note: json['note']?.toString(),
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
      reporter:
          json['users'] != null ? ReporterModel.fromJson(json['users']) : null,
      modul:
          json['modul'] != null
              ? ReportedModulModel.fromJson(json['modul'])
              : null,
    );
  }
}

class ReporterModel {
  final int? userId;
  final String? username;
  final String? email;

  ReporterModel({this.userId, this.username, this.email});

  factory ReporterModel.fromJson(Map<String, dynamic> json) {
    return ReporterModel(
      userId: json['user_id'],
      username: json['username']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

class ReportedModulModel {
  final int? modulId;
  final String? judul;
  final String? status;
  final String? thumbnailUrl;

  final ReportedAuthorModel? penulis;

  ReportedModulModel({
    this.modulId,
    this.judul,
    this.status,
    this.thumbnailUrl,
    this.penulis,
  });

  factory ReportedModulModel.fromJson(Map<String, dynamic> json) {
    return ReportedModulModel(
      modulId: json['modul_id'],
      judul: json['judul']?.toString(),
      status: json['status']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      penulis:
          json['penulis'] != null
              ? ReportedAuthorModel.fromJson(json['penulis'])
              : null,
    );
  }
}

class ReportedAuthorModel {
  final int? userId;
  final String? username;

  ReportedAuthorModel({this.userId, this.username});

  factory ReportedAuthorModel.fromJson(Map<String, dynamic> json) {
    return ReportedAuthorModel(
      userId: json['user_id'],
      username: json['username']?.toString(),
    );
  }
}

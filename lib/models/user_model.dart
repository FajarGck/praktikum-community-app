class UsersModel {
  int? userId;
  String? username;
  String? password;
  String? email;
  String? fotoProfil;
  String? createdAt;
  String? updatedAt;
  String? role;

  UsersModel({
    this.userId,
    this.username,
    this.role,
    this.password,
    this.email,
    this.fotoProfil,
    this.createdAt,
    this.updatedAt,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    fotoProfil = json['foto_profil'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['foto_profil'] = fotoProfil;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['role'] = role;
    return data;
  }
}

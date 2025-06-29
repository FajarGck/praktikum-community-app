import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['API_BASE_URL']!;

  // list endpoit
  static String get getImage => '$baseUrl/';
  static String get getAllAuthor => '$baseUrl/users';
  static String get kategori => '$baseUrl/kategori';
  static String get me => '$baseUrl/auth/me';
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get createAdmin => '$baseUrl/users/admin';
  static String get getAllModul => '$baseUrl/modul';
  static String get createKomentar => '$baseUrl/komentar';

  static String getKategoriById(int id) => '$baseUrl/kategori/$id';
  static String userById(int id) => '$baseUrl/users/$id';
  static String getDetailModulById(int id) => '$baseUrl/modul/$id';
  static String getCardModulByUserId(int id) => '$baseUrl/modul/user/$id';
  static String getCardModulByKategoriId(int id) =>
      '$baseUrl/modul/kategori/$id';
  static String searchModul(String query) =>
      '$baseUrl/modul/search?judul=$query';
}

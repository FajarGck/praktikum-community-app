import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['API_BASE_URL']!;

  // contoh endpoint GET all data
  static String get getImage => '$baseUrl/';
  static String get getAllAuthor => '$baseUrl/users';
  static String get kategori => '$baseUrl/kategori';
  static String get me => '$baseUrl/auth/me';
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get createAdmin => '$baseUrl/users/admin';
  static String get getAllModul => '$baseUrl/modul';
  static String get createKomentar => '$baseUrl/komentar';

  // contoh endpoint GET single by id
  static String getKategoriById(int id) => '$baseUrl/kategori/$id';
  static String userById(int id) => '$baseUrl/users/$id';
  static String getDetailModulById(int id) => '$baseUrl/modul/$id';
  static String getCardModulByUserId(int id) => '$baseUrl/modul/card/$id';
  static String searchModul(String query) =>
      '$baseUrl/modul/search?judul=$query';
}

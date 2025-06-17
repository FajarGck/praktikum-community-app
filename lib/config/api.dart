import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String _base = dotenv.env['API_BASE_URL']!;

  // contoh endpoint GET all data
  static String get getAllUsers => '$_base/users';
  static String get getAllKategori => '$_base/kategori';
  static String get me => '$_base/me';
  static String get login => '$_base/auth/login';
  static String get register => '$_base/auth/register';

  // contoh endpoint GET single by id
  static String getKategoriById(int id) => '$_base/kategori/$id';
  static String userById(int id) => '$_base/users/$id';
}

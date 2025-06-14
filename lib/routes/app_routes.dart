import 'package:flutter/material.dart';

// Import semua halaman yang akan digunakan
import '../ui/pages/auth/login_page.dart';
import '../ui/pages/auth/register_page.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/modul/create_modul_page.dart';
import '../ui/pages/modul/detail_modul_page.dart';
import '../ui/pages/modul/komentar_page.dart';
import '../ui/pages/profile/edit_profile_page.dart';
import '../ui/pages/profile/profile_page.dart';
import '../ui/pages/search/search_page.dart';
import '../ui/pages/modul/module_list_page.dart';
import '../ui/pages/authors/authors_page.dart';

class AppRoutes {
  //tinggal panggil nama
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createModul = '/create-modul';
  static const String detailModul = '/detail-modul';
  static const String komentar = '/komentar';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String search = '/search';
  static const String listmodul = '/module-list';
  static const String authors = '/authors';

  //daftar root biar lebih terstruktur
  static final Map<String, WidgetBuilder> routes = {
    // login: (context) => const LoginPage(),
    // register: (context) => const RegisterPage(),
    home: (context) => const HomePage(),
    // createModul: (context) => const CreateModulPage(),
    // detailModul: (context) => const DetailModulPage(),
    // komentar: (context) => const KomentarPage(),
    // profile: (context) => const ProfilePage(),
    // editProfile: (context) => const EditProfilePage(),
    // search: (context) => const SearchPage(),
    // listmodul: (context) => const ModuleListPage(),
    // authors: (context) => const AuthorsPage(),
  };
}

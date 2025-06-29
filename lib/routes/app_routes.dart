import 'package:flutter/material.dart';
import 'package:tugas_akhir/ui/pages/auth/create_admin.dart';
import 'package:tugas_akhir/ui/pages/authors/admin_page.dart';
import 'package:tugas_akhir/ui/pages/kategori/kategori_page.dart';
import 'package:tugas_akhir/ui/pages/modul/modul_kategory_page.dart';
import 'package:tugas_akhir/ui/widgets/modul_detail.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/ui/pages/modul/edit_modul_page.dart';
import '../ui/pages/auth/login_page.dart';
import '../ui/pages/auth/register_page.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/modul/create_modul_page.dart';
import '../ui/pages/profile/edit_profile_page.dart';
import '../ui/pages/profile/profile_page.dart';
import '../ui/pages/modul/module_list_page.dart';
import '../ui/pages/authors/authors_page.dart';
import '../ui/pages/search/search_result_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createModul = '/create-modul';
  static const String detailModul = '/detail-modul';
  static const String modulKategori = '/modul-kategori';
  static const String komentar = '/komentar';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String search = '/search';
  static const String listmodul = '/module-list';
  static const String authors = '/authors';
  static const String admin = '/admin';
  static const String kategori = '/kategori';
  static const String createAdmin = '/create-admin';
  static const String searchResult = '/search-result';
  static const String editModul = '/edit-modul';
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    home: (context) => const HomePage(),
    admin: (context) => const AdminPage(),
    profile: (context) => const ProfilePage(),
    authors: (context) => const AuthorsPage(),
    kategori: (context) => const KategoriPage(),
    createAdmin: (context) => const CreateAdmin(),
    listmodul: (context) => const ModuleListPage(),
    editProfile: (context) => const EditProfilePage(),
    detailModul: (context) {
      final settings = ModalRoute.of(context)!.settings;
      final modulId = settings.arguments as int;
      return DetailModulPage(modulId: modulId);
    },
    modulKategori: (context) {
      final settings = ModalRoute.of(context)!.settings;
      final kategoriId = settings.arguments as int;
      return ModulKategoriPage(kategoriId: kategoriId);
    },
    searchResult: (context) {
      final query = ModalRoute.of(context)!.settings.arguments as String;
      return SearchResultPage(searchQuery: query);
    },
    createModul: (context) => const CreateModulPage(),
    editModul: (context) {
      final modul = ModalRoute.of(context)!.settings.arguments as ModulModel;
      return EditModulPage(modul: modul);
    },
  };
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/models/auth_response.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/service/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _service = AuthService();
  final _storage = const FlutterSecureStorage();

  String? _token;
  String? get token => _token;

  AuthResponse? _authData;
  AuthResponse? get authData => _authData;

  bool _loading = false;
  bool get isLoading => _loading;
  bool get isLoggedIn => _token != null;

  String requireToken() {
    final t = _token;
    if (t == null || t.isEmpty) {
      throw StateError(
        "Unauthorized: token is missing. User must login again.",
      );
    }
    return t;
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await _service.register(
        username: username,
        password: password,
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUser({
    required BuildContext context,
    required int userId,
    required Map<String, dynamic> data,
  }) async {
    final token = requireToken();
    _loading = true;
    notifyListeners();
    try {
      final updateUser = await _service.updateUser(
        token: token,
        id: userId,
        data: data,
      );
      _authData = AuthResponse(token: _token!, user: updateUser);
      _onLoginSuccess(context, _token!);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> init() async {
    _token = await _storage.read(key: 'jwt_token');
    notifyListeners();
    return _token;
  }

  Future<void> _onLoginSuccess(BuildContext context, String token) async {
    await Future.wait([
      context.read<AuthorProvider>().fetchAuthor(token),
      context.read<KategoriProvider>().fetchKategori(token),
      context.read<ModulProvider>().fetchModul(token: token),
    ]);
  }

  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    notifyListeners();
    try {
      final data = await _service.login(username: username, password: password);
      _authData = data;
      _token = data.token;
      await _storage.write(key: 'jwt_token', value: _token);
      await _onLoginSuccess(context, _token!);
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _authData = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }

  Future<void> autoLogin({required BuildContext context}) async {
    _loading = true;
    notifyListeners();
    try {
      final savedToken = await _storage.read(key: 'jwt_token');
      if (savedToken != null) {
        final data = await _service.getUserProfile(savedToken);
        _token = savedToken;
        _authData = AuthResponse(token: savedToken, user: data);
      }
      if (context.mounted) {
        await _onLoginSuccess(context, savedToken!);
      } else {
        _token = null;
      }
    } catch (e) {
      await logout();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

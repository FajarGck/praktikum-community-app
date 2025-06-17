import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/auth_response.dart';
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

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _loading = false;
    notifyListeners();
    try {
      await _service.register(
        username: username,
        password: password,
        email: email,
      );
    } catch (e) {
      throw e.toString();
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

  Future<void> login({
    required String username,
    required String password,
  }) async {
    notifyListeners();
    try {
      final data = await _service.login(username: username, password: password);
      _authData = data;
      _token = data.token;
      await _storage.write(key: 'jwt_token', value: _token);
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> autoLogin() async {
    _loading = true;
    notifyListeners();
    try {
      final savedToken = await _storage.read(key: 'jwt_token');
      if (savedToken != null) {
        final data = await _service.getUserProfile(savedToken);
        _token = savedToken;
        _authData = AuthResponse(token: savedToken, user: data);
        print('✅ profile loaded: ${_authData!.user.username}');
      }
    } catch (e) {
      _token = null;
      _authData = null;
    } finally {
      _loading = false;
      notifyListeners();
      print('◀ autoLogin end, isLoggedIn=${isLoggedIn}');
    }
  }
}

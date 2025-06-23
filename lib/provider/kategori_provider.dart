import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/service/kategori_service.dart';

class KategoriProvider with ChangeNotifier {
  final _service = KategoriService();

  bool _isLoading = false;
  List<KategoriModel> _kategoriList = [];
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  List<KategoriModel> get kategoriList => _kategoriList;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> fetchKategori(String? token) async {
    if (token == null) {
      _errorMessage = "Token tidak valid untuk fetch kategori.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _kategoriList = await _service.listKategori(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearKategori() async {
    _kategoriList = [];
    _errorMessage = null;
    _successMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createKategori({
    required String token,
    required String kategoriName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    try {
      final message = await _service.createKategori(token, kategoriName);
      _successMessage = message;
      await fetchKategori(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateKategori({
    required String token,
    required String id,
    required String kategoriName,
  }) async {
    _isLoading = false;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    try {
      await _service.updateKategori(token, id, kategoriName);
      await fetchKategori(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteKategori({
    required String token,
    required String id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    try {
      final message = await _service.deleteKategori(token, id);
      _successMessage = message;
      await fetchKategori(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

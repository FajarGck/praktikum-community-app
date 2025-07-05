import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/provider/favorit_provider.dart';
import 'package:tugas_akhir/service/favorit_service.dart';
import 'package:tugas_akhir/service/komentar_service.dart';
import 'package:tugas_akhir/service/modul_service.dart';

class ModulProvider with ChangeNotifier {
  final _service = ModulService();
  final _komentarService = KomentarService();
  final _favoritService = FavoritService();

  bool _isLoading = false;
  bool _isKomentar = false;
  List<ModulModel> _modulList = [];
  List<ModulModel> _modulListByUserId = [];
  List<ModulModel> _modulListByKategoriId = [];
  ModulModel? _detailModul;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isKomentar => _isKomentar;
  List<ModulModel> get modulList => _modulList;
  List<ModulModel> get modulListByUserId => _modulListByUserId;
  List<ModulModel> get modulListByKategoriId => _modulListByKategoriId;
  ModulModel? get detailModul => _detailModul;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool _isSearching = false;
  List<ModulModel> _searchResultList = [];

  bool get isSearching => _isSearching;
  List<ModulModel> get searchResultList => _searchResultList;

  Future<void> fetchModul(String? token) async {
    if (token == null) {
      _errorMessage = "Token tidak valid";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _modulList = await _service.listModul(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchModulByUserId(String? token, int userId) async {
    if (token == null) {
      _errorMessage = "Token tidak valid";
      scheduleMicrotask(notifyListeners);
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    scheduleMicrotask(notifyListeners);
    try {
      _modulListByUserId = await _service.listModulByUserId(token, userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      scheduleMicrotask(notifyListeners);
    }
  }

  Future<void> fetchModulByKategoriId(String? token, int kategoriId) async {
    if (token == null) {
      _errorMessage = "Token tidak valid";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _modulListByKategoriId = await _service.listModulByKategoriId(
        token,
        kategoriId,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetailModul(String? token, int modulId) async {
    if (token == null) {
      _errorMessage = "Token tidak valid";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _detailModul = await _service.getDetailModul(token, modulId);
      if (_detailModul != null) {
        _detailModul!.isFavorit = await _favoritService.checkIsFavorited(
          token!,
          modulId,
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createKomentar({
    required String token,
    required int modulId,
    required String isiKomentar,
  }) async {
    _isKomentar = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final komentar = await _komentarService.createKomentar(
        token: token,
        modulId: modulId,
        isiKomentar: isiKomentar,
      );
      _isKomentar = false;
      if (_detailModul != null && _detailModul!.komentar != null) {
        _detailModul!.komentar!.insert(0, komentar);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isKomentar = false;
      notifyListeners();
    }
  }

  Future<void> searchModul({
    required String token,
    required String query,
  }) async {
    if (query.isEmpty) {
      _searchResultList = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _service.searchModul(token, query);
      _searchResultList = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> clearModul() async {
    _modulList = [];
    _modulListByUserId = [];
    _modulListByKategoriId = [];
    _searchResultList = [];
    _detailModul = null;
    _errorMessage = null;
    _successMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createModul({
    required String token,
    required String judul,
    required String deskripsi,
    required int kategoriId,
    required File thumbnailImage,
    required List<Map<String, dynamic>> langkah,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.createModul(
        token: token,
        judul: judul,
        deskripsi: deskripsi,
        kategoriId: kategoriId,
        thumbnailImage: thumbnailImage,
        langkah: langkah,
      );
      await fetchModul(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateModul({
    required String token,
    required int modulId,
    required String judul,
    required String deskripsi,
    required int kategoriId,
    File? thumbnailImage,
    required List<Map<String, dynamic>> langkah,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.updateModul(
        token: token,
        modulId: modulId,
        judul: judul,
        deskripsi: deskripsi,
        kategoriId: kategoriId,
        thumbnailImage: thumbnailImage,
        langkah: langkah,
      );
      _successMessage = "Modul berhasil diperbarui";
      await fetchModul(token);
      await fetchDetailModul(token, modulId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDetailFavorit(
    String token,
    FavoritProvider favoritProvider,
  ) async {
    if (_detailModul == null) return;

    final modulToUpdate = _detailModul!;
    final isCurrentlyFavorited = modulToUpdate.isFavorit;

    modulToUpdate.isFavorit = !isCurrentlyFavorited;
    notifyListeners();

    try {
      await _favoritService.toggleFavorit(token, modulToUpdate.modulId!);
      await favoritProvider.getFavorit(token);
    } catch (e) {
      modulToUpdate.isFavorit = isCurrentlyFavorited;
      _errorMessage = "Gagal mengubah status favorit: ${e.toString()}";
      notifyListeners();
    }
  }
}

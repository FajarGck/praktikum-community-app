import 'package:flutter/widgets.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/service/komentar_service.dart';
import 'package:tugas_akhir/service/modul_service.dart';

class ModulProvider with ChangeNotifier {
  final _service = ModulService();
  final _komentarService = KomentarService();

  bool _isLoading = false;
  bool _isKomentar = false;
  List<ModulModel> _modulList = [];
  ModulModel? _detailModul;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isKomentar => _isKomentar;
  List<ModulModel> get modulList => _modulList;
  ModulModel? get detailModul => _detailModul;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

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
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _modulList = await _service.listModulById(token, userId);
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

  Future<void> clearModul() async {
    _modulList = [];
    _errorMessage = null;
    _successMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

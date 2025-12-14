import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/report_model.dart';
import 'package:tugas_akhir/service/report_service.dart';

class ReportProvider with ChangeNotifier {
  final _service = ReportService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  Future<String> submitReport({
    required String token,
    required int modulId,
    required String reason,
    String? note,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _service.createReport(
        token: token,
        modulId: modulId,
        reason: reason,
        note: note,
      );

      final msg = (res['message'] ?? 'OK').toString();
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
      return _errorMessage!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingReports({required String token}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _reports = await _service.getPendingReports(token: token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> hideModul({required String token, required int modulId}) async {
    try {
      await _service.updateModulStatus(
        token: token,
        modulId: modulId,
        status: 'reject',
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteModulAsAdmin({
    required String token,
    required int modulId,
  }) async {
    try {
      await _service.adminDeleteModul(token: token, modulId: modulId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _reports = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

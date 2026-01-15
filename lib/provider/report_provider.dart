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

  // Submit Laporan Baru
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

  // Fetch untuk ADMIN (Semua Data)
  Future<void> fetchPendingReports({required String token}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _reports = await _service.getPendingReports(token: token);
    } catch (e) {
      _errorMessage = e.toString();
      _reports = []; // Kosongkan jika error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- PERBAIKAN DI SINI ---
  // Fetch untuk USER BIASA (Data User Itu Sendiri)
  Future<void> fetchUserReports({
    required String token,
    required int userId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Memberitahu UI loading mulai
    
    try {
      // Panggil service getUserReports yang sudah diperbaiki
      final data = await _service.getUserReports(token: token, userId: userId);
      
      // Simpan ke variable _reports agar muncul di ProfilePage
      _reports = data; 
      
    } catch (e) {
      print("Error fetchUserReports: $e");
      _errorMessage = e.toString();
      _reports = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Memberitahu UI data siap
    }
  }
  // -------------------------

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
import 'package:flutter/material.dart';
import '../service/laporan_service.dart';

class LaporanProvider with ChangeNotifier {
  final LaporanService _service = LaporanService();
  
  // State
  bool _isLoading = false;
  List<dynamic> _listLaporan = []; // [PENTING] Variabel penampung data

  // Getter (Ini yang dipanggil UI: provider.listLaporan)
  bool get isLoading => _isLoading;
  List<dynamic> get listLaporan => _listLaporan;

  // 1. Fungsi Lapor (User)
  Future<bool> laporModul(int modulId, String kategori, String deskripsi) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _service.kirimLaporan(
      modulId: modulId,
      kategori: kategori,
      deskripsi: deskripsi,
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // 2. [BARU] Fungsi Fetch Data (Admin)
  // Dipanggil saat halaman Admin dibuka
  Future<void> fetchAllLaporan() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ambil data dari service
      final data = await _service.getAllLaporan();
      _listLaporan = data;
    } catch (e) {
      print("Error provider fetch laporan: $e");
      _listLaporan = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 3. [BARU] Fungsi Hapus (Admin)
  // Dipanggil saat tombol "Selesai" ditekan
  Future<bool> hapusLaporan(int id) async {
    // Kita hapus dulu dari UI biar terasa cepat (Optimistic UI)
    // atau hapus setelah sukses. Di sini kita hapus setelah sukses.
    
    bool success = await _service.deleteLaporan(id);
    
    if (success) {
      // Hapus item dari list lokal agar UI terupdate tanpa loading ulang
      _listLaporan.removeWhere((item) => item['laporan_id'] == id);
      notifyListeners();
    }
    
    return success;
  }
}
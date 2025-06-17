import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/service/kategori_service.dart';

class KategoriProvider with ChangeNotifier {
  final _service = KategoriService();

  List<KategoriModel> _kategoriList = [];
  List<KategoriModel> get kategoriList => _kategoriList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchKategori() async {
    try {
      _kategoriList = await _service.listKategori();
      print(_kategoriList);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}

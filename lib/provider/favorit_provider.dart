import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/service/favorit_service.dart';

class FavoritProvider with ChangeNotifier {
  final FavoritService _favoritService = FavoritService();
  List<ModulModel> _favoritList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ModulModel> get favoritList => _favoritList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getFavorit(String token) async {
    _isLoading = true;
    scheduleMicrotask(notifyListeners);
    try {
      final fetchedList = await _favoritService.getFavorit(token);
      _favoritList = fetchedList;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      scheduleMicrotask(notifyListeners);
    }
  }

  Future<void> toggleFavorit(String token, int modulId) async {
    try {
      await _favoritService.toggleFavorit(token, modulId);
      await getFavorit(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearFavorit() async {
    _favoritList = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

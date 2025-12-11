import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/models/user_model.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/service/author_service.dart';
// [PENTING] Tambahkan import ini untuk fitur sanksi
import 'package:http/http.dart' as http;
import '../config/api.dart';

class AuthorProvider with ChangeNotifier {
  final _service = AuthorService();

  bool _isLoading = false;
  List<UsersModel> _authorList = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<UsersModel> get authorList => _authorList;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAuthor(String? token) async {
    if (token == null) {
      _errorMessage = "Sesi tidak valid. Silakan login kembali.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authorList = await _service.listAuthor(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAdmin({
    required String token,
    required String username,
    required String password,
    required String email,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.createAdmin(
        token: token,
        username: username,
        password: password,
        email: email,
        role: role,
      );
      fetchAuthor(token);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // [METHOD BARU: Sanksi User]
  // Method ini yang dicari oleh LaporanAdminPage
  Future<bool> toggleSanction(String token, int userId) async {
    try {
      // Endpoint: /users/{id}/sanksi
      final uri = Uri.parse('${ApiEndpoints.getAllAuthor}/$userId/sanksi');
      
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Refresh data author jika perlu
        notifyListeners(); 
        return true;
      } else {
        debugPrint("Gagal sanksi user: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error sanksi: $e");
      return false;
    }
  }

  Future<void> clearAuthor() async {
    _authorList = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> LoadInitialData(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;
    
    if (token != null) {
      await Future.wait([
        fetchAuthor(token),
        context.read<KategoriProvider>().fetchKategori(token),
      ]);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/ui/widgets/authors_list.dart';
import 'package:tugas_akhir/ui/widgets/kategori_list.dart';
import 'package:tugas_akhir/ui/widgets/modul_list.dart';
import '../../../config/theme.dart';
import '../../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Default di Home

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      _searchFocusNode.unfocus();
      final authProvider = context.read<AuthProvider>();

      context
          .read<ModulProvider>()
          .searchModul(token: authProvider.token!, query: query)
          .then((_) {
        Navigator.pushNamed(
          context,
          AppRoutes.searchResult,
          arguments: query,
        );
      });
    }
  }

  // Fungsi Navigasi Bawah
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home (Stay here)
        break;
      case 1: // Module
        Navigator.pushNamed(context, AppRoutes.listmodul);
        break;
      case 2: // Authors
        Navigator.pushNamed(context, AppRoutes.authors);
        break;
      case 3: // Profile
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
      case 4: // Admin (Hanya jika tombolnya ada)
        Navigator.pushNamed(context, AppRoutes.admin);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final author = context.watch<AuthorProvider>();
    final kategori = context.watch<KategoriProvider>();
    final modul = context.watch<ModulProvider>();

    return Scaffold(
      // --- FAB (Tombol Tambah) dengan Logika Sanksi ---
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final user = auth.authData?.user;
          // Default true jika null (anggap innocent)
          final bool canUpload = user?.canUpload ?? true;

          return FloatingActionButton(
            backgroundColor: canUpload ? AppTheme.primaryColor : Colors.grey,
            onPressed: () {
              if (canUpload) {
                Navigator.pushNamed(context, AppRoutes.createModul);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "AKSES DIBATASI: Fitur upload Anda dinonaktifkan sementara.",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Icon(canUpload ? Icons.add : Icons.block, color: Colors.white),
          );
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            children: [
              // Header
              const SizedBox(height: 8),
              const Text(
                "Home",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Search Bar
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => _performSearch(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Cari modul...',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _performSearch(_searchController.text),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Kategori
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Kategori Modul", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.kategori),
                        child: const Text("See all", style: TextStyle(color: AppTheme.primaryColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  KategoriList(provider: kategori, maxItems: 4),
                ],
              ),
              
              const SizedBox(height: 32),

              // Post Terbaru
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Post Terbaru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.listmodul),
                    child: const Text("See all", style: TextStyle(color: AppTheme.primaryColor)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ModulList(listModul: modul.modulList, direction: Axis.horizontal, maxItems: 5),
              
              const SizedBox(height: 32),

              // Authors
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Authors", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.authors),
                        child: const Text("See all", style: TextStyle(color: AppTheme.primaryColor)),
                      ),
                    ],
                  ),
                  authorList(author),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION BAR (YANG HARUS DI-UPDATE) ---
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          // 1. Definisikan item standar (4 biji)
          final List<BottomNavigationBarItem> navItems = [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Module'),
            const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Authors'),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ];

          // 2. [LOGIKA PENTING] Cek apakah user adalah ADMIN
          // Debug Print ini akan muncul di terminal untuk memastikan role user
          final role = auth.authData?.user.role;
          print("🔍 DEBUG: User Role saat ini = $role"); 

          if (role == 'admin') {
            // Jika admin, tambahkan tombol ke-5
            navItems.add(
              const BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
              ),
            );
          }

          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed, // Agar layout tidak bergeser
            items: navItems,
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.listmodul);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.authors);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
      case 4:
        if (context.read<AuthProvider>().authData?.user.role == 'admin') {
          Navigator.pushNamed(context, AppRoutes.admin);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final author = context.watch<AuthorProvider>();
    final kategori = context.watch<KategoriProvider>();
    final modul = context.watch<ModulProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createModul);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Text(
                "Home",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _performSearch(_searchController.text),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kategori Modul",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.kategori);
                        },
                        child: Text(
                          "See all",
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  KategoriList(provider: kategori, maxItems: 4),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Post Terbaru",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap:
                        () => Navigator.pushNamed(context, AppRoutes.listmodul),
                    child: Text(
                      "See all",
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ModulList(
                listModul: modul.modulList,
                direction: Axis.horizontal,
                maxItems: 5,
              ),
              const SizedBox(height: 32),

              // Authors
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Authors",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.authors);
                        },
                        child: Text(
                          "See all",
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
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
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final navItems = [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Module',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Authors'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ];
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            items: navItems,
          );
        },
      ),
    );
  }
}

// lib/ui/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';
import 'package:tugas_akhir/ui/widgets/modul_list.dart';
import '../../../config/theme.dart';
import '../../../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.listmodul);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.authors);
        break;
      case 3:
        break;
    }
  }

  int? _previousUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.watch<AuthProvider>();

    final currentUserId = auth.authData?.user.userId;
    if (currentUserId != null && currentUserId != _previousUserId) {
      _previousUserId = currentUserId;
      final modulProvider = context.read<ModulProvider>();
      modulProvider.fetchModulByUserId(auth.authData!.token, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createModul);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) return const Loading();
          final imageUrl =
              '${ApiEndpoints.baseUrl}${auth.authData?.user.fotoProfil}';
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFD9D9D9),
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${auth.authData?.user.username}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${auth.authData?.user.email}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                '${auth.authData?.user.role}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Publication",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Consumer<ModulProvider>(
                      builder: (context, modul, child) {
                        if (modul.modulListByUserId.isEmpty) {
                          return SizedBox(
                            height: 50,
                            child: Text("Belum ada Postingan"),
                          );
                        }
                        return ModulList(
                          listModul: modul.modulListByUserId,
                          direction: Axis.horizontal,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (auth.authData?.user.role == 'admin')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.createAdmin);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Create Admin"),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.editProfile);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      child: const Text("Settings Account"),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        final authProvider = context.read<AuthProvider>();
                        final authorProvider = context.read<AuthorProvider>();
                        final kategoriProvider =
                            context.read<KategoriProvider>();
                        final modulProvder = context.read<ModulProvider>();
                        authProvider.logout();
                        authorProvider.clearAuthor();
                        kategoriProvider.clearKategori();
                        modulProvder.clearModul();

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (routes) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Module'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Authors'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

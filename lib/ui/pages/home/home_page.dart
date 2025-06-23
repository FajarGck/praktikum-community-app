import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/ui/widgets/authors_list.dart';
import 'package:tugas_akhir/ui/widgets/kategori_list.dart';
import '../../../config/theme.dart';
import '../../../provider/modul_provider.dart';
import '../../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> categories = [
    "Pemrograman Mobile",
    "Pemrograman Website",
    "Pemrograman Berbasis Event",
    "Basis Data",
  ];

  final List<Map<String, String>> recentPosts = [
    {
      'title': 'Pengenalan OOP',
      'desc': 'OOP adalah paradigma pemrograman berbasis objek...',
      'author': 'Reza Pambudi',
    },
    {
      'title': 'Fetching API',
      'desc': 'OOP adalah pendekatan modular untuk data...',
      'author': 'Reza Pambudi',
    },
  ];

  final List<Map<String, dynamic>> authors = [
    {
      "user_id": 23,
      "username": "Gwen",
      "email": "guys@gmail.com",
      "foto_profil":
          "/public/images/users/1749808114618-e334cb95-8b3c-4b26-be17-bc6529f1d5c9.jpg",
      "created_at": "2025-06-13T09:48:34.000Z",
      "updated_at": "2025-06-13T09:48:34.000Z",
      "role": "admin",
    },
    {
      "user_id": 44,
      "username": "Alfred",
      "email": "alf@gmail.com",
      "foto_profil": "/public/images/users/profile.png",
      "created_at": "2025-06-17T05:13:38.000Z",
      "updated_at": "2025-06-17T05:13:38.000Z",
      "role": "user",
    },
    {
      "user_id": 45,
      "username": "Baru",
      "email": "baru@gmail.com",
      "foto_profil": "/public/images/users/profile.png",
      "created_at": "2025-06-17T13:10:38.000Z",
      "updated_at": "2025-06-17T13:10:38.000Z",
      "role": "user",
    },
    {
      "user_id": 46,
      "username": "Gwendi",
      "email": "a@gmail.com",
      "foto_profil": "/public/images/users/profile.png",
      "created_at": "2025-06-17T15:39:23.000Z",
      "updated_at": "2025-06-17T15:39:23.000Z",
      "role": "user",
    },
    {
      "user_id": 47,
      "username": "Alvin14",
      "email": "alvin@gmail.com",
      "foto_profil": "/public/images/users/profile.png",
      "created_at": "2025-06-18T13:54:32.000Z",
      "updated_at": "2025-06-18T13:54:32.000Z",
      "role": "user",
    },
    {
      "user_id": 48,
      "username": "Dendy11",
      "email": "dendy@gmail.com",
      "foto_profil": "/public/images/users/profile.png",
      "created_at": "2025-06-18T13:55:15.000Z",
      "updated_at": "2025-06-18T13:55:15.000Z",
      "role": "user",
    },
    {
      "user_id": 49,
      "username": "Emyl",
      "email": "emyl@gmail.com",
      "foto_profil": "/public/images/users/profile.png",
      "created_at": "2025-06-18T13:55:35.000Z",
      "updated_at": "2025-06-18T13:55:35.000Z",
      "role": "user",
    },
  ];

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
        Navigator.pushNamed(context, AppRoutes.admin);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final author = context.watch<AuthorProvider>();
    final kategori = context.watch<KategoriProvider>();
    final role = auth.authData?.user.role;
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

              // Search Field
              TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    final token = context.read<AuthProvider>().token;
                    context.read<ModulProvider>().searchModul(
                      token: token!,
                      query: value,
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.searchResult,
                      arguments: value,
                    );
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
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
                ),
              ),
              const SizedBox(height: 24),
              // Kategori Modul
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
                  KategoriList(provider: kategori, maxItems: 3),
                ],
              ),
              const SizedBox(height: 32),

              // Post Terbaru
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
                  Text(
                    "See all",
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentPosts.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final post = recentPosts[index];
                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post['desc']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                post['author']!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              //author
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
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.authors,
                          );
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
          if (auth.authData?.user.role == 'admin') {
            navItems.add(
              BottomNavigationBarItem(
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
            items: navItems,
          );
        },
      ),
    );
  }
}

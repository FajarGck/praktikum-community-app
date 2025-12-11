import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/config/theme.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/routes/app_routes.dart';
import 'package:tugas_akhir/ui/widgets/kategori_list.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 4; // Default aktif di tab Admin

  // Fungsi Navigasi Bottom Bar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Kalau tab sama, jangan reload

    setState(() => _selectedIndex = index);

    // Gunakan pushReplacement agar tidak menumpuk halaman (lebih ringan)
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.listmodul);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.authors);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
      case 4:
        // Sudah di halaman admin
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tombol Tambah Modul (Floating Action Button)
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createModul),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) return const Loading();

          final user = auth.authData?.user;
          final imageUrl = (user?.fotoProfil != null) 
              ? '${ApiEndpoints.baseUrl}${user!.fotoProfil}' 
              : null;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Header Profil (Foto & Nama Admin)
                _buildProfileHeader(user?.username, user?.email, imageUrl),
                
                const SizedBox(height: 32),

                // 2. Menu Tools Admin
                const Text(
                  "Admin Tools", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const SizedBox(height: 12),

                // Menu: Laporan Masuk
                _buildMenuCard(
                  title: "Laporan Masuk",
                  subtitle: "Cek dan tindak lanjuti laporan user",
                  icon: Icons.report_gmailerrorred_rounded,
                  color: Colors.redAccent,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.laporanAdmin),
                ),

                const SizedBox(height: 12),

                // Menu: Buat Admin Baru
                _buildMenuCard(
                  title: "Buat Admin Baru",
                  subtitle: "Tambah akun administrator lain",
                  icon: Icons.person_add_alt_1_rounded,
                  color: Colors.blueAccent,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.createAdmin),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),

                // 3. Section Kelola Kategori
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kategori Modul",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.kategori),
                      child: const Text(
                        "Kelola",
                        style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // List Kategori
                Consumer<KategoriProvider>(
                  builder: (context, kategori, child) =>
                      KategoriList(provider: kategori, maxItems: 5),
                ),
                
                const SizedBox(height: 80), // Jarak aman agar tidak tertutup FAB
              ],
            ),
          );
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final isAdmin = auth.authData?.user.role == 'admin';
          
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed, // Agar layout stabil > 3 item
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Module'),
              const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Authors'),
              const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              // Menu Admin (Hanya muncul jika Role = Admin)
              if (isAdmin)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings),
                  label: 'Admin',
                ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER (Agar kodingan utama bersih) ---

  Widget _buildProfileHeader(String? name, String? email, String? imageUrl) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFD9D9D9),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null ? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
          ),
          const SizedBox(height: 12),
          Text(
            name ?? "Admin",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            email ?? "-",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "ADMINISTRATOR",
              style: TextStyle(
                fontSize: 10, 
                fontWeight: FontWeight.bold, 
                color: AppTheme.primaryColor,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
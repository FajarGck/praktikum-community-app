import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/routes/app_routes.dart';
// import 'package:tugas_akhir/routes/app_routes.dart';
import 'package:tugas_akhir/ui/widgets/authors_box.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';
import '../../../config/theme.dart';

class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  int _selectedIndex = 2;

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
    return Consumer<AuthorProvider>(
      builder: (context, author, child) {
        if (author.isLoading) return const Scaffold(body: Loading());
        return Scaffold(
          bottomNavigationBar: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final navItems = [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Module',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Authors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
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
          appBar: AppBar(
            title: const Text("authors", style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              itemCount: author.authorList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1,
              ),

              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AuthorsBox(author: author.authorList[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

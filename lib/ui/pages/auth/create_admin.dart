import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/theme.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/ui/widgets/input/secret_input.dart';
import 'package:tugas_akhir/ui/widgets/input/standar_input.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _dropdownValue = 'user';

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) return const Loading();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Create new Admin",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StandarInput(
                      label: "Username",
                      controller: _usernameController,
                      hint: "Alfred",
                    ),
                    const SizedBox(height: 8),
                    StandarInput(
                      label: "email",
                      controller: _emailController,
                      hint: "Alfred",
                    ),
                    const SizedBox(height: 8),
                    SecretInput(
                      label: "password",
                      controller: _passwordController,
                      hint: "Alfred",
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: DropdownButton(
                        items: [
                          DropdownMenuItem(value: "user", child: Text("User")),
                          DropdownMenuItem(
                            value: "admin",
                            child: Text("Admin"),
                          ),
                        ],
                        value: _dropdownValue,
                        onChanged: dropdownCallback,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Consumer<AuthorProvider>(
                      builder: (context, author, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await author.createAdmin(
                                  token: auth.token.toString(),
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  email: _emailController.text,
                                  role: _dropdownValue,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Admin berhasil ditambahkan",
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  // print(e.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Tambahkan",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

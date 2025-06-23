import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/ui/widgets/input/secret_input.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';
import 'package:tugas_akhir/ui/widgets/standar_input.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final user = auth.authData!.user;
          _usernameController.text = user.username.toString();
          _emailController.text = user.email.toString();
          _passwordController.text = '';
          if (auth.isLoading) return const Loading();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    StandarInput(
                      label: 'Username',
                      controller: _usernameController,
                    ),
                    SizedBox(height: 12),
                    SecretInput(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Password',
                    ),
                    SizedBox(height: 12),
                    StandarInput(label: 'Email', controller: _emailController),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final Map<String, dynamic> dataToUpdate = {};

                          if (_usernameController.text != user.username) {
                            dataToUpdate['username'] = _usernameController.text;
                          }
                          if (_emailController.text != user.email) {
                            dataToUpdate['email'] = _emailController.text;
                          }
                          if (_passwordController.text.isNotEmpty) {
                            dataToUpdate['password'] = _passwordController.text;
                          }
                          if (dataToUpdate.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tidak ada data yang diubah."),
                              ),
                            );
                            return;
                          }
                          final success = await auth.updateUser(
                            context: context,
                            userId: user.userId!,
                            data: dataToUpdate,
                          );
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Data berhasil diubah."),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/ui/widgets/input/standar_input.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';

class CreateModulPage extends StatefulWidget {
  const CreateModulPage({super.key});

  @override
  State<CreateModulPage> createState() => _CreateModulPageState();
}

class _CreateModulPageState extends State<CreateModulPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final List<TextEditingController> _langkahControllers = [
    TextEditingController(),
  ];

  File? _thumbnailImage;
  int? _selectedKategoriId;
  bool _isUploading = false;

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    for (var controller in _langkahControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _thumbnailImage = File(pickedFile.path);
      });
    }
  }

  void _addLangkah() {
    setState(() {
      _langkahControllers.add(TextEditingController());
    });
  }

  void _removeLangkah(int index) {
    if (_langkahControllers.length > 1) {
      setState(() {
        _langkahControllers[index].dispose();
        _langkahControllers.removeAt(index);
      });
    }
  }

  Future<void> _submitForm() async {
    print("1. Tombol Submit Ditekan.");

    if (_formKey.currentState!.validate()) {
      if (_thumbnailImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih gambar thumbnail')),
        );
        return;
      }
      if (_selectedKategoriId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Silakan pilih kategori')));
        return;
      }

      setState(() {
        _isUploading = true;
      });

      final langkahList =
          _langkahControllers.asMap().entries.map((entry) {
            return {
              'urutan': entry.key + 1,
              'deskripsi_langkah': entry.value.text,
            };
          }).toList();

      final authProvider = context.read<AuthProvider>();
      final modulProvider = context.read<ModulProvider>();

      print("2. Data yang akan dikirim ke Provider:");
      print("   - Judul: ${_judulController.text}");
      print("   - Kategori ID: $_selectedKategoriId");
      print("   - Langkah: $langkahList");

      try {
        final success = await modulProvider.createModul(
          token: authProvider.token!,
          judul: _judulController.text,
          deskripsi: _deskripsiController.text,
          kategoriId: _selectedKategoriId!,
          thumbnailImage: _thumbnailImage!,
          langkah: langkahList,
        );

        if (mounted) {
          if (success) {
            print("5. SUKSES! Modul berhasil di-upload.");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Modul berhasil di-upload!')),
            );
            Navigator.of(context).pop();
          } else {
            print(
              "5. GAGAL! Pesan dari provider: ${modulProvider.errorMessage}",
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  modulProvider.errorMessage ?? 'Gagal mengupload modul',
                ),
              ),
            );
          }
        }
      } catch (e) {
        print("Error di UI Layer: $e");
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan watch di sini agar UI rebuild jika kategori berubah
    final kategoriProvider = context.watch<KategoriProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Modul Baru'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Modul
                  StandarInput(
                    controller: _judulController,
                    label: "Judul Modul",
                    hint: "Contoh: Membuat REST API dengan Express.js",
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Judul tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi Singkat
                  StandarInput(
                    controller: _deskripsiController,
                    label: "Deskripsi Singkat",
                    hint: "Deskripsikan modul Anda secara singkat",
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Deskripsi tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Kategori
                  DropdownButtonFormField<int>(
                    value: _selectedKategoriId,
                    hint: const Text('Pilih Kategori'),
                    items:
                        kategoriProvider.kategoriList.map((
                          KategoriModel kategori,
                        ) {
                          return DropdownMenuItem<int>(
                            value: kategori.kategoriId,
                            child: Text(kategori.namaKategori ?? 'Tanpa Nama'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedKategoriId = value;
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? 'Kategori harus dipilih' : null,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Upload Thumbnail
                  const Text(
                    "Thumbnail Modul",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          _thumbnailImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _thumbnailImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Pilih Gambar",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Langkah-langkah Dinamis
                  const Text(
                    "Langkah-langkah",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _langkahControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Text("${index + 1}."),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: StandarInput(
                                controller: _langkahControllers[index],
                                label: "Langkah ${index + 1}",
                                hint: "Deskripsi langkah ke-${index + 1}",

                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Langkah tidak boleh kosong'
                                            : null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color:
                                    _langkahControllers.length > 1
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              onPressed: () => _removeLangkah(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Langkah"),
                    onPressed: _addLangkah,
                  ),
                  const SizedBox(height: 32),

                  // Tombol Submit
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _submitForm,
                      child: const Text(
                        'Upload Modul',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (_isUploading) const Loading(),
        ],
      ),
    );
  }
}

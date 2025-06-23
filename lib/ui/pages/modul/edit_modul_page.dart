import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/api.dart';
import 'package:tugas_akhir/models/kategori_model.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/provider/auth_provider.dart';
import 'package:tugas_akhir/provider/kategori_provider.dart';
import 'package:tugas_akhir/provider/modul_provider.dart';
import 'package:tugas_akhir/ui/widgets/input/standar_input.dart';
import 'package:tugas_akhir/ui/widgets/loading.dart';

class EditModulPage extends StatefulWidget {
  final ModulModel modul; // Menerima data modul yang akan diedit

  const EditModulPage({super.key, required this.modul});

  @override
  State<EditModulPage> createState() => _EditModulPageState();
}

class _EditModulPageState extends State<EditModulPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late List<TextEditingController> _langkahControllers;

  File? _newThumbnailImage; // Untuk menyimpan gambar baru yang dipilih
  int? _selectedKategoriId;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Isi semua controller dan state dengan data dari modul yang ada
    _judulController = TextEditingController(text: widget.modul.judul);
    _deskripsiController = TextEditingController(text: widget.modul.deskripsi);
    _selectedKategoriId = widget.modul.kategoriId;

    // Isi langkah-langkah
    _langkahControllers =
        widget.modul.langkah?.map((langkah) {
          return TextEditingController(text: langkah.deskripsiLangkah);
        }).toList() ??
        [
          TextEditingController(),
        ]; // Jika tidak ada langkah, buat satu yang kosong

    if (_langkahControllers.isEmpty) {
      _langkahControllers.add(TextEditingController());
    }
  }

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
        _newThumbnailImage = File(pickedFile.path);
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

  Future<void> _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
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

      try {
        final success = await modulProvider.updateModul(
          token: authProvider.token!,
          modulId: widget.modul.modulId!,
          judul: _judulController.text,
          deskripsi: _deskripsiController.text,
          kategoriId: _selectedKategoriId!,
          thumbnailImage:
              _newThumbnailImage, // Kirim gambar baru jika ada, jika tidak, kirim null
          langkah: langkahList,
        );

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Modul berhasil diperbarui!')),
            );
            Navigator.of(context).pop(); // Kembali ke halaman detail
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  modulProvider.errorMessage ?? 'Gagal memperbarui modul',
                ),
              ),
            );
          }
        }
      } catch (e) {
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
    final kategoriProvider = context.watch<KategoriProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Modul'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form fields (judul, deskripsi, kategori, dll)
                  // UI ini sama persis dengan halaman create, jadi kita bisa copy-paste
                  // dan hanya mengubah fungsi tombol submit.
                  StandarInput(
                    controller: _judulController,
                    label: "Judul Modul",
                    hint: "Judul: gass",
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Judul tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  StandarInput(
                    controller: _deskripsiController,
                    label: "Deskripsi Singkat",
                    hint: "deskiprsi singkat",
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Deskripsi tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedKategoriId,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            _newThumbnailImage != null
                                ? Image.file(
                                  _newThumbnailImage!,
                                  fit: BoxFit.cover,
                                )
                                : Image.network(
                                  "${ApiEndpoints.baseUrl}${widget.modul.thumbnailUrl}",
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Ketuk gambar untuk mengganti",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
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
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _isUploading
                              ? null
                              : _submitUpdate, // Panggil fungsi update
                      child: const Text(
                        'Update Modul',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isUploading) const Loading(),
        ],
      ),
    );
  }
}

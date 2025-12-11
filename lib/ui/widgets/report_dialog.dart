import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/config/theme.dart';
import '../../provider/laporan_provider.dart';

class ReportDialog extends StatefulWidget {
  final int modulId;
  const ReportDialog({super.key, required this.modulId});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _selectedCategory;

  // Map untuk opsi dropdown (Value API : Teks Tampilan)
  final Map<String, String> _kategoriOptions = {
    'modul_bermasalah': 'Modul Bermasalah/Error',
    'tidak_etis': 'Konten Tidak Etis/Kasar',
    'tidak_sesuai': 'Isi Tidak Sesuai Judul',
    'lainnya': 'Lainnya',
  };

  @override
  Widget build(BuildContext context) {
    final laporanProvider = Provider.of<LaporanProvider>(context);

    return AlertDialog(
      title: const Text("Laporkan Modul"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Apa masalahnya?", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              
              // DROPDOWN
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                hint: const Text("Pilih Alasan"),
                value: _selectedCategory,
                items: _kategoriOptions.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) => val == null ? 'Wajib dipilih' : null,
              ),
              
              const SizedBox(height: 15),
              
              // TEXT FIELD
              const Text("Jelaskan detailnya:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Contoh: Ada kata kasar di langkah ke-3...",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Deskripsi tidak boleh kosong';
                  if (val.length < 10) return 'Deskripsi terlalu singkat';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
        ),
        
        // TOMBOL KIRIM (Tampilkan loading jika sedang proses)
        laporanProvider.isLoading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor:AppTheme.primaryColor),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool success = await laporanProvider.laporModul(
                      widget.modulId,
                      _selectedCategory!,
                      _deskripsiController.text,
                    );

                    if (context.mounted) {
                      Navigator.pop(context); // Tutup dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success 
                            ? "Laporan berhasil dikirim! Terima kasih." 
                            : "Gagal mengirim laporan."),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text("LAPORKAN", style: TextStyle(color: Colors.white)),
              ),
      ],
    );
  }
}
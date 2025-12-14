// Consumer<ModulProvider>(
//   builder: (context, provider, child) {
//     final modul = provider.detailModul;
//     if (modul == null) return const SizedBox.shrink();

//     return IconButton(
//       icon: const Icon(Icons.flag_outlined),
//       tooltip: 'Laporkan konten',
//       onPressed: () async {
//         String reason = 'not_academic';
//         final noteController = TextEditingController();

//         final confirm = await showDialog<bool>(
//           context: context,
//           builder: (dialogContext) {
//             return AlertDialog(
//               title: const Text('Laporkan postingan'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: reason,
//                     items: const [
//                       DropdownMenuItem(value: 'spam', child: Text('Spam')),
//                       DropdownMenuItem(value: 'not_academic', child: Text('Tidak akademik')),
//                       DropdownMenuItem(value: 'harassment', child: Text('Harassment')),
//                       DropdownMenuItem(value: 'plagiarism', child: Text('Plagiarisme')),
//                       DropdownMenuItem(value: 'other', child: Text('Lainnya')),
//                     ],
//                     onChanged: (v) => reason = v ?? 'not_academic',
//                     decoration: const InputDecoration(labelText: 'Alasan'),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: noteController,
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                       labelText: 'Catatan (opsional)',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(dialogContext, false),
//                   child: const Text('Batal'),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(dialogContext, true),
//                   child: const Text('Kirim'),
//                 ),
//               ],
//             );
//           },
//         );

//         if (confirm != true) return;

//         final auth = context.read<AuthProvider>();
//         final token = auth.token!;
//         final reportProvider = context.read<ReportProvider>();

//         final ok = await reportProvider.submitReport(
//           token: token,
//           modulId: widget.modulId,
//           reason: reason,
//           note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
//         );

//         if (!context.mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(ok
//                 ? 'Laporan dikirim. Terima kasih.'
//                 : (reportProvider.errorMessage ?? 'Gagal mengirim laporan')),
//           ),
//         );
//       },
//     );
//   },
// ),

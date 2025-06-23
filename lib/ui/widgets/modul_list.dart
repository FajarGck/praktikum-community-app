import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/modul_model.dart';
import 'package:tugas_akhir/ui/widgets/modul_card.dart';

class ModulList extends StatelessWidget {
  final List<ModulModel> listModul;
  final int? maxItems;
  final Axis direction;

  const ModulList({
    super.key,
    required this.listModul,
    this.maxItems,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: direction,
        itemCount: maxItems ?? 3,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ModulCard(modul: listModul[index]);
        },
      ),
    );
  }
}

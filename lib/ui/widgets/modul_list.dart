// lib/ui/widgets/modul_list.dart

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
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: direction,
        itemCount: maxItems ?? listModul.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index >= listModul.length) {
            return const SizedBox.shrink();
          }
          return ModulCard(modul: listModul[index]);
        },
      ),
    );
  }
}

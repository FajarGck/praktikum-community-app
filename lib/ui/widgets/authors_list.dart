import 'package:flutter/material.dart';
import 'package:tugas_akhir/provider/author_provider.dart';
import 'package:tugas_akhir/ui/widgets/authors_box.dart';

Widget authorList(AuthorProvider provider) {
  if (provider.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  return SizedBox(
    height: 150,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        if (index >= provider.authorList.length) return Container();
        if (provider.authorList.isEmpty) return Container();
        final author = provider.authorList[index];
        return AuthorsBox(author: author);
      },
    ),
  );
}

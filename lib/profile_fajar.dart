import 'package:flutter/material.dart';

class ProfileFajar extends StatefulWidget {
  const ProfileFajar({super.key});

  @override
  State<ProfileFajar> createState() => _ProfileFajarState();
}

class _ProfileFajarState extends State<ProfileFajar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nama: Fajar Ramadhan"),
        Text("NIM: 23SA31A065"),
        Text("Kelas: TI23B"),
      ],
    );
  }
}

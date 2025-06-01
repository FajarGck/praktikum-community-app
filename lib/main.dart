import 'package:flutter/material.dart';
import 'package:tugas_akhir/Profile/halaman.profile.dart';
import 'package:tugas_akhir/profile_fajar.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PROJEK AKHIR PMO TI23B")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [ProfileFajar(), Halamanprofile()]),
      ),
    );
  }
}

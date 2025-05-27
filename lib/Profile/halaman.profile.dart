import 'package:flutter/material.dart';

class Halamanprofile extends StatefulWidget {
  const Halamanprofile({super.key});

  @override
  State<Halamanprofile> createState() => _HalamanprofileState();
}

class _HalamanprofileState extends State<Halamanprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Halaman Profile")),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image(
                    height: 50,
                    width: 50,
                    image: NetworkImage(
                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fdepositphotos.com%2Fid%2Fvectors%2Fdummy-person.html&psig=AOvVaw3k3iBCMQ4Cb2xRscjOLdSw&ust=1748419573847000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCIis-c-Yw40DFQAAAAAdAAAAABAE",
                    ),
                  ),
                ),
                Text("Halo saya adalah saya dan saya pusing"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  const Credits({super.key});

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Lookout by 22CLC10 - T1"),
            Divider(
              color: Colors.blueGrey,
              thickness: 2,
            ),
            Text("Developers", style: TextStyle(fontWeight: FontWeight.w900)),
            SizedBox(height: 5),
            Text("Hà Gia Bảo"),
            Text("Võ Đăng Khoa"),
            Text("Lê Trí Mẩn"),
            Text("Cao Phạm Hoàng Thái"),
            Text("Lê Ngọc Vĩ"),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}

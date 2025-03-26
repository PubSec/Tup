import 'package:flutter/material.dart';
import 'package:tup/views/scan_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TUp")),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => ScanView()));
              },
              child: Text("Recharge"),
            ),
          ],
        ),
      ),
    );
  }
}

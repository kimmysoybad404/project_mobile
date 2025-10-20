import 'package:flutter/material.dart';
import 'package:project_mobile/Staff/manage_assets_page2.dart';

void main() {
  runApp(const ManageAssetsApp());
}

class ManageAssetsApp extends StatelessWidget {
  const ManageAssetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Cherry Bomb One', // ใช้ฟอนต์เดียวกับ main เดิม
      ),
      home: const ManageAssetsPage2(),
    );
  }
}

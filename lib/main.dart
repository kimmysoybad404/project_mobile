import 'package:flutter/material.dart';
import 'package:project_mobile/BottomBar.dart';
import 'package:project_mobile/LoginPage.dart';
import 'package:project_mobile/identify_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(headlineLarge: TextStyle(letterSpacing: 10)),
        primarySwatch: Colors.blue,
        fontFamily: 'Chewy',
      ),
      home: IdentifyPage(),
    );
  }
}

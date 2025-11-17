// utils.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const url = "10.0.2.2:3000";

const storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await storage.write(key: "token", value: token);
}

Future<String> getToken(BuildContext context) async {
  String? token = await storage.read(key: "token");

  if (token == null || token.isEmpty) {
    popDialog(context, "Error", "Token not found, please login again.");
    return "";
  }

  return "Bearer $token";
}

Future<String> getTokenNoContext() async {
  String? token = await storage.read(key: "token");
  if (token == null || token.isEmpty) {
    throw Exception("Token missing");
  }
  return token;  
}

Future<void> deleteToken() async {
  await storage.delete(key: "token");
}

void popDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

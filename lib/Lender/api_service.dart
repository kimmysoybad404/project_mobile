// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'request_item.dart';
import '../utils.dart' as util;

class ApiService {
  final String _baseUrl = "http://10.0.2.2:3000/api";

  // ดึงรายการ Pending Requests
  Future<List<RequestItem>> fetchPendingRequests({String query = ""}) async {
    try {
      final token = await util.getTokenNoContext(); // 👈 ไม่ใช้ context

      final uri = Uri.parse("$_baseUrl/pending-requests?search=$query");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token", // 👈 แก้ตัวใหญ่ + ไม่ซ้ำ Bearer
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => RequestItem.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load (Status: ${response.statusCode})");
      }
    } catch (e) {
      print("ApiService Error: $e");
      throw Exception("Server error: $e");
    }
  }

  // Approve Request
  Future<bool> approveRequest(String historyId, String lenderId) async {
    final token = await util.getTokenNoContext();

    final response = await http.post(
      Uri.parse("$_baseUrl/requests/$historyId/approve"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"lenderId": lenderId}),
    );

    return response.statusCode == 200;
  }

  // Reject Request
  Future<bool> rejectRequest(
    String historyId,
    String lenderId,
    String reason,
  ) async {
    final token = await util.getTokenNoContext();

    final response = await http.post(
      Uri.parse("$_baseUrl/requests/$historyId/reject"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"reason": reason, "lenderId": lenderId}),
    );

    return response.statusCode == 200;
  }
}

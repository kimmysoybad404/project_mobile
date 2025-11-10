// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'request_item.dart'; // Import model ที่เราสร้าง

class ApiService {
  // TODO: เปลี่ยน 'YOUR_API_BASE_URL' เป็น URL จริงของคุณ
  final String _baseUrl = "http://10.0.2.2:3000/api";

  // ดึงรายการที่รออนุมัติ
  Future<List<RequestItem>> fetchPendingRequests({String query = ""}) async {
    try {
      // เพิ่ม query parameter ถ้ามีการค้นหา
      final uri = Uri.parse("$_baseUrl/pending-requests?search=$query"); 
      
      // TODO: เพิ่ม Headers ถ้าจำเป็น (เช่น Authorization)
      final response = await http.get(uri); 

      if (response.statusCode == 200) {
        // สำเร็จ
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => RequestItem.fromJson(json)).toList();
      } else {
        // ไม่สำเร็จ
        throw Exception("Failed to load requests (Status: ${response.statusCode})");
      }
    } catch (e) {
      // เกิด Error
      print("ApiService Error: $e");
      throw Exception("Error connecting to server: $e");
    }
  }

  // TODO: สร้าง API สำหรับ Approve/Reject
Future<bool> approveRequest(String historyId, String lenderId) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/requests/$historyId/approve"), // 3. เปลี่ยนชื่อ id เป็น historyId (เพื่อความชัดเจน)
      
      // 👇 4. เพิ่ม headers และ body
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'lenderId': lenderId,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> rejectRequest(String id, String lenderId, String reason) async {
    print(reason + lenderId);
    final response = await http.post(
      Uri.parse("$_baseUrl/requests/$id/reject"),
      body: {'reason': reason,
            'lenderId': lenderId
      }, 
    );
    return response.statusCode == 200;
  }
}
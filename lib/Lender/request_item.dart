// request_item.dart
import 'package:flutter/foundation.dart';

class RequestItem {
  final String id;
  final String assetName;
  final String image; // แค่ชื่อไฟล์ เช่น 'notebook.png'
  final String borrowDate;
  final String returnDate;
  final String borrowerName; // ควรมารวมจาก API

  RequestItem({
    required this.id,
    required this.assetName,
    required this.image,
    required this.borrowDate,
    required this.returnDate,
    required this.borrowerName,
  });

  // Factory constructor เพื่อแปลง JSON
  factory RequestItem.fromJson(Map<String, dynamic> json) {
    return RequestItem(
      id: json['id']?.toString() ?? '',
      assetName: json['assetName'] ?? 'Unknown Asset',
      image: json['image'] ?? 'default.png',
      // TODO: คุณอาจต้อง Format วันที่ที่นี่
      borrowDate: json['borrowDate'] ?? 'N/A', 
      returnDate: json['returnDate'] ?? 'N/A',
      borrowerName: json['borrowerName'] ?? 'Unknown User',
    );
  }
}
import 'package:flutter/material.dart';

class HistoryItem {
  final int id;
  final int assetID;
  final String assetName;
  final String? image;
  final DateTime borrowDate;
  final DateTime returnDate; // วันที่คาดว่าจะคืน
  final DateTime? actualReturnDate; // ✅ 1. วันที่คืนจริง (อาจเป็น NULL)
  final int? borrowBy;
  final int? approveBy;
  final int? receiveBy;
  final int? rejectBy;
  final String? rejectReason;
  final String? approverName;
  final String? receiverName;
  final String? rejecterName;
  final String? borrowerName;

  HistoryItem({
    required this.id,
    required this.assetID,
    required this.assetName,
    required this.borrowDate,
    required this.returnDate,
    this.actualReturnDate, // ✅ 2. เพิ่มใน constructor
    this.borrowBy,
    this.approveBy,
    this.receiveBy,
    this.rejectBy,
    this.rejectReason,
    this.image,
    this.approverName,
    this.receiverName,
    this.rejecterName,
    this.borrowerName,
  });

  // Factory constructor to parse JSON
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      assetID: json['assetID'],
      assetName: json['assetName'] ?? 'No Name',
      image: json["image"],
      borrowDate: DateTime.parse(json['BorrowDate']).toLocal(),
      returnDate: DateTime.parse(json['ReturnDate']).toLocal(),
      
      // ✅ 3. เพิ่ม Logic รับค่า (ต้องเช็ค NULL ด้วย)
      actualReturnDate: json['ActualReturnDate'] == null
          ? null
          : DateTime.parse(json['ActualReturnDate']).toLocal(),
      
      borrowBy: json['BorrowBy'],
      approveBy: json['ApproveBy'],
      receiveBy: json['ReceiveBy'],
      rejectBy: json['RejectBy'],
      rejectReason: json['RejectReason'],
      approverName: json['approverName'],
      receiverName: json['receiverName'],
      rejecterName: json['rejecterName'],
      borrowerName: json['borrowerName'],
    );
  }

  // Get the status as a displayable string
  String get displayStatus {
    if (approveBy == null && rejectBy == null) return "Pending";
    if (rejectBy != null) return "Rejected";
    if (approveBy != null && receiveBy == null) return "Approved";
    if (receiveBy != null) return "Received";
    return "Unknown";
  }

  // Get the status color for your UI
  Color get statusColor {
    final s = displayStatus.toLowerCase();

    if (s == 'rejected') {
      return Colors.red[700]!; // 🟥 Rejected = สีแดง
    }

    if (s == 'returned') {
      return Colors.orange[800]!; // 🟧 Returned = สีส้ม
    }

    if (s == 'approved') {
      return Colors.green[700]!; // 🟩 Approved = สีเขียว
    }

    if (s == 'pending') {
      return const Color(0xFFF9E076); // 🟨 Pending = สีเหลือง
    }

    return Colors.grey[600]!; // อื่นๆ = สีเทา
  }
}

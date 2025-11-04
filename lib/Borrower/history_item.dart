import 'package:flutter/material.dart';

class HistoryItem {
  final int id;
  final int assetID;
  final String assetName;
  final String? image;
  final DateTime borrowDate;
  final DateTime returnDate;
  final int? borrowBy;
  final int? approveBy;
  final int? receiveBy;
  final int? rejectBy;
  final String? rejectReason;
  // final String? status; // ไม่ได้ใช้แล้ว
  final String? approverName;
  final String? receiverName;
  final String? rejecterName; // ✅ 1. เพิ่มตัวแปรนี้

  HistoryItem({
    required this.id,
    required this.assetID,
    required this.assetName,
    required this.borrowDate,
    required this.returnDate,
    this.borrowBy,
    this.approveBy,
    this.receiveBy,
    this.rejectBy,
    this.rejectReason,
    this.image,
    // this.status, // ไม่ได้ใช้แล้ว
    this.approverName,
    this.receiverName,
    this.rejecterName, // ✅ 2. เพิ่มใน constructor
  });

  // Factory constructor to parse JSON
  // Factory constructor to parse JSON
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      assetID: json['assetID'],
      assetName: json['assetName'] ?? 'No Name',
      image: json["image"],
      
      borrowDate: DateTime.parse(json['BorrowDate']).toLocal(),
      returnDate: DateTime.parse(json['ReturnDate']).toLocal(),
      
      borrowBy: json['BorrowBy'],
      approveBy: json['ApproveBy'],
      receiveBy: json['ReceiveBy'],
      rejectBy: json['RejectBy'],
      rejectReason: json['RejectReason'],
      approverName: json['approverName'],
      receiverName: json['receiverName'],
      rejecterName: json['rejecterName'],
    );
  }

  // Get the status as a displayable string
  String get displayStatus {
    // Logic หลัก: เช็คจากค่า NULL
    if (rejectBy != null) {
      return 'Rejected';
    }
    if (receiveBy != null) {
      return 'Returned';
    }
    if (approveBy != null) {
      return 'Approved';
    }
    
    // (กันเหนียว) ถ้าทุกอย่างเป็น NULL
    return 'Pending';
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
import 'package:flutter/material.dart';

class HistoryItem {
  final int id;
  final int assetID;
  final String assetName;
  final String? image;
  final DateTime borrowDate;
  final DateTime returnDate;
  final int? borrowBy;
  final int? approveBy; // เพิ่ม field นี้
  final int? receiveBy;
  final int? rejectBy;
  final String? rejectReason;
  final String? status; // เพิ่ม field นี้
  final String? approverName; // เพิ่ม field นี้
  final String? receiverName; // เพิ่ม field นี้

  HistoryItem({
    required this.id,
    required this.assetID,
    required this.assetName,
    required this.borrowDate,
    required this.returnDate,
    this.borrowBy,
    this.approveBy, // เพิ่มใน constructor
    this.receiveBy,
    this.rejectBy,
    this.rejectReason,
    this.image,
    this.status, // เพิ่มใน constructor
    this.approverName, // เพิ่มใน constructor
    this.receiverName, // เพิ่มใน constructor
  });

  // Factory constructor to parse JSON
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      assetID: json['assetID'],
      assetName: json['assetName'] ?? 'No Name', // เพิ่ม fallback
      image: json["image"],
      borrowDate: DateTime.parse(json['BorrowDate']),
      returnDate: DateTime.parse(json['ReturnDate']),
      borrowBy: json['BorrowBy'],
      approveBy: json['ApproveBy'], // ดึงข้อมูล
      receiveBy: json['ReceiveBy'],
      rejectBy: json['RejectBy'],
      rejectReason: json['RejectReason'],
      status: json['status'], // ดึงข้อมูล
      approverName: json['approverName'], // ดึงข้อมูล
      receiverName: json['receiverName'], // ดึงข้อมูล
    );
  }

  // Get the status as a displayable string
  String get displayStatus {
    // ใช้ status จาก DB เป็นหลัก
    if (status != null && status!.isNotEmpty) {
      // ทำให้เป็นตัวพิมพ์ใหญ่ตัวแรก
      return status![0].toUpperCase() + status!.substring(1).toLowerCase();
    }

    // Logic สำรอง (ถ้า DB ไม่มีคอลัมน์ Status)
    if (rejectBy != null) {
      return 'Rejected';
    }
    if (receiveBy != null) {
      return 'Returned'; // สมมติว่า ReceiveBy คือการคืนของแล้ว
    }
    if (approveBy != null) {
      return 'Approved';
    }
    return 'Pending';
  }

  // Get the status color for your UI
  Color get statusColor {
    final s = displayStatus.toLowerCase(); // 
    
    if (s == 'rejected') {
      return Colors.red[700]!; // 🟥 Rejected = สีแดง
    }

    if (s == 'returned') {
      return Colors.orange[800]!; // 🟧 Returned = สีส้ม (ตามที่คุณต้องการ)
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
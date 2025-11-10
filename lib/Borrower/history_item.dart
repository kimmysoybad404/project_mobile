import 'package:flutter/material.dart';

class HistoryItem {
  final int id;
  final int assetID;
  final String assetName;
  final String? image;
  final DateTime borrowDate;
  final DateTime returnDate;
  final DateTime? actualReturnDate;
  final int? borrowBy;
  final int? approveBy;
  final int? receiveBy;
  final int? rejectBy;
  final String? rejectReason;
  // final String? status; // ไม่ได้ใช้แล้ว
  final String? approverName;
  final String? receiverName;
  final String? rejecterName; // ✅ 1. เพิ่มตัวแปรนี้
final String? borrowerName;

  HistoryItem({
    required this.id,
    required this.assetID,
    required this.assetName,
    required this.borrowDate,
    required this.returnDate,
    required this.actualReturnDate,
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
    this.borrowerName,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? 0,
      assetID: json['assetID'] ?? 0,
      assetName: json['assetName'] ?? 'No Name',
      image: json['image'] ?? 'assets/placeholder.png',
      borrowDate: DateTime.parse(json['BorrowDate']).toLocal(),
      returnDate: DateTime.parse(json['ReturnDate']).toLocal(),
      actualReturnDate: json['ActualReturnDate'] != null
          ? DateTime.parse(json['ActualReturnDate']).toLocal()
          : null,
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
    if (receiveBy != null) return "Returned";
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

import 'package:flutter/material.dart'; // Import for 'Color'

class HistoryItem {
  final int id;
  final int assetID;
  final String assetName;
  final String? image;
  final DateTime borrowDate;
  final DateTime returnDate;
  final int? borrowBy;
  final int? receiveBy;
  final int? rejectBy;
  final String? rejectReason;

  HistoryItem({
    required this.id,
    required this.assetID,
    required this.assetName,
    required this.borrowDate,
    required this.returnDate,
    this.borrowBy,
    this.receiveBy,
    this.rejectBy,
    this.rejectReason,
    this.image,
  });

// Factory constructor to parse JSON
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      // ✅ Use lowercase keys
      id: json['id'],
      assetID: json['assetID'],
      assetName: json['assetName'],
      image: json["image"],
      borrowDate: DateTime.parse(json['BorrowDate']),
      returnDate: DateTime.parse(json['ReturnDate']),
      borrowBy: json['BorrowBy'],
      receiveBy: json['ReceiveBy'],
      rejectBy: json['RejectBy'],
      rejectReason: json['RejectReason'],
    );
  }

  // --- 🔽 ADD THESE GETTERS 🔽 ---

  // Get the status as a displayable string
  String get statusString {
    if (rejectBy != null) {
      return 'Rejected';
    }
    if (receiveBy != null) {
      return 'Approved';
    }
    return 'Waiting for approve';
  }

  // Get the status color for your UI
  Color get statusColor {
    if (rejectBy != null) {
      return Colors.red;
    }
    if (receiveBy != null) {
      return Colors.green;
    }
    return const Color(0xFFF9E076); // Yellow for 'Pending'
  }
}
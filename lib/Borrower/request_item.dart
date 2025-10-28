// request_item.dart
class RequestItem {
  final String id;
  final String name;
  final String image;
  final String status;
  final DateTime borrowDate;  // เพิ่ม
  final DateTime returnDate;  // เพิ่ม

  RequestItem({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.borrowDate,
    required this.returnDate,
  });
}
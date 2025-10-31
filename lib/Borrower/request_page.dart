import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'request_item.dart';

class RequestPage extends StatefulWidget {
  final RequestItem? newItem;

  const RequestPage({super.key, this.newItem});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int _selectedTabIndex = 0;
  final Color DarkBrown = const Color(0xFF8B5B46);
  final Color LightBrown = const Color(0xFFFEC785);

  final DateTime _borrowDate = DateTime.now();
  final DateTime _returnDate = DateTime.now().add(const Duration(days: 3));

  RequestItem? _pendingItem;
  List<RequestItem> requestItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.newItem != null) {
      _pendingItem = RequestItem(
        id: widget.newItem!.id,
        name: widget.newItem!.name,
        image: widget.newItem!.image,
        borrowDate: _borrowDate,
        returnDate: _returnDate,
        status: 'Pending',
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter, 
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DarkBrown,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabs(),
                  const SizedBox(height: 12),
                  const Text(
                    "*You can only request once a day.",
                    style: TextStyle(color: Color(0xFFF48A8A), fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  IndexedStack(
                    index: _selectedTabIndex,
                    children: [_buildAllRequestCards(), _buildStatusCard()],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabItem("Request info", 0),
          _buildTabItem("Status", 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? LightBrown : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4A3831),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Request Info Tab
  Widget _buildAllRequestCards() {
    if (_pendingItem == null) {
      return const Center(
        child: Text("No item selected", style: TextStyle(color: Colors.white)),
      );
    }
    return _buildRequestInfoCard(_pendingItem!);
  }

  Widget _buildRequestInfoCard(RequestItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightBrown,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildDeviceImage(item),
              const SizedBox(width: 16),
              _buildDeviceInfo(item),
            ],
          ),
          const SizedBox(height: 16),
          _buildDateField("Borrow", _borrowDate),
          const SizedBox(height: 12),
          _buildDateField("Return", _returnDate),
          const SizedBox(height: 20),
          _buildRequestButton(item),
        ],
      ),
    );
  }

  Widget _buildDeviceImage(RequestItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DarkBrown,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFADDB9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(item.image),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(RequestItem item) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "ID:${item.id}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F0D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Status: ${item.status}",
              style: const TextStyle(
                color: Color(0xFF5A8E41),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE9D3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.calendar_today_rounded, color: DarkBrown),
              ),
              Expanded(
                child: Text(
                  DateFormat('d/M/yyyy').format(date),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3831),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ ปุ่ม Request Now: ย้าย item ไป Status แล้วลบออกจาก Request info
  Widget _buildRequestButton(RequestItem item) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkBrown,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () {
          setState(() {
            final exists = requestItems.any((i) => i.id == item.id);
            if (!exists) {
              requestItems.add(
                RequestItem(
                  id: item.id,
                  name: item.name,
                  image: item.image,
                  borrowDate: _borrowDate,
                  returnDate: _returnDate,
                  status: 'Pending',
                ),
              );
            }
            _pendingItem = null; // ✅ ลบออกจาก Request info
            _selectedTabIndex = 1; // ✅ สลับไป Status
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${item.name} added to Request List ✅")),
          );
        },
        child: Text(
          "Request now",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightBrown,
          ),
        ),
      ),
    );
  }

  // 🔹 Status Tab
  Widget _buildStatusCard() {
    if (requestItems.isEmpty) {
      return const Center(
        child: Text(
          "No items requested yet",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: requestItems.map((item) => _buildStatusItemCard(item)).toList(),
    );
  }

  Widget _buildStatusItemCard(RequestItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: LightBrown, width: 5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${item.id}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Name: ${item.name}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 100, height: 100, child: Image.asset(item.image)),
              Expanded(
                child: Column(
                  children: [
                    _buildStatusDateRow(
                      "Borrow",
                      DateFormat('d/M/yyyy').format(item.borrowDate),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusDateRow(
                      "Return",
                      DateFormat('d/M/yyyy').format(item.returnDate),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Waiting for approve",
              style: TextStyle(
                color: Color(0xFFF9E076),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDateRow(String label, String date) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: LightBrown,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF4A3831),
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF4A3831),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

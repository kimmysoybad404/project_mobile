import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_mobile/Borrower/history_item.dart';
import 'request_item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestPage extends StatefulWidget {
  final RequestItem? newItem;

  const RequestPage({super.key, this.newItem});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String? _userId;
  String? _errortxt;
  String? _statusError;
  bool _isStatusLoading = false;
  int _selectedTabIndex = 0;
  final Color DarkBrown = const Color(0xFF8B5B46);
  final Color LightBrown = const Color(0xFFFEC785);

  final DateTime _borrowDate = DateTime.now();
  final DateTime _returnDate = DateTime.now().add(const Duration(days: 1));

  RequestItem? _pendingItem;
  List<RequestItem> requestItems = [];
  List<HistoryItem> _historyItems = [];
  List<HistoryItem> historyItemFromJson(String str) {
    final List<dynamic> decodedJson = jsonDecode(str);
    return decodedJson
        .map((item) => HistoryItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _fetchStatusRequests(String userId) async {
    // Set loading state
    setState(() {
      _isStatusLoading = true;
      _statusError = null;
    });

    final url = Uri.parse('http://10.0.2.2:3000/user-requests/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Use your existing parser
        final List<HistoryItem> items = historyItemFromJson(response.body);
        setState(() {
          _historyItems = items;
          _isStatusLoading = false;
        });
      } else {
        setState(() {
          _statusError = "Server error: ${response.statusCode}";
          _isStatusLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching status: $e');
      setState(() {
        _statusError = "Failed to load data. Check connection.";
        _isStatusLoading = false;
      });
    }
  }

  Future<bool> requestItemAndUpdateStatus(
    String itemId,
    DateTime borrowDate,
    DateTime returnDate,
    String userId,
  ) async {
    final url = Uri.parse(
      'http://10.0.2.2:3000/update-storage',
    ); // Your endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': itemId, // For the UPDATE
          'status': 'Pending', // For the UPDATE
          'assetID': itemId, // For the INSERT
          'borrowDate': borrowDate.toIso8601String(), // For the INSERT
          'returnDate': returnDate.toIso8601String(), // For the INSERT
          'borrowBy': userId, // For the INSERT
        }),
      );

      if (response.statusCode == 200) {
        // Success
        print('Update successful!');
        print('Response body: ${response.body}');
        return true;
        // You can parse the response.body if your server sends back data
        // final data = jsonDecode(response.body);
      } else {
        // Server error
        print('Failed to update status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _errortxt = response.body;
        });
        return false;
      }
    } catch (e) {
      // Network or other error
      print('Error sending request: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    if (widget.newItem != null) {
      _pendingItem = RequestItem(
        id: widget.newItem!.id,
        name: widget.newItem!.name,
        image: widget.newItem!.image,
        borrowDate: _borrowDate,
        returnDate: _returnDate,
        status: 'Available',
      );
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid') ?? '';

    setState(() {
      _userId = userId;
    });

    if (userId.isNotEmpty) {
      // This will now run every time the page loads
      _fetchStatusRequests(userId);
    } else {
      // Handle case where user is not logged in
      setState(() {
        _isStatusLoading = false;
        _statusError = "User not logged in.";
      });
    }
  }

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
        onPressed: () async {
          bool updateSucceeded = false;
          try {
            updateSucceeded = await requestItemAndUpdateStatus(
              item.id,
              _borrowDate,
              _returnDate,
              _userId ?? "",
            );
          } catch (e) {
            updateSucceeded = false;
          }

          if (updateSucceeded) {
            // 🔽 --- REFRESH LOGIC --- 🔽
            if (_userId != null) {
              // Refetch the list from the server
              _fetchStatusRequests(_userId!);
            }

            setState(() {
              _pendingItem = null; // Clear Request info tab
              _selectedTabIndex = 1; // Switch to Status tab
            });
            // 🔼 --- END REFRESH --- 🔼

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${item.name} added to Request List ✅")),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_errortxt ?? "Request failed"), // Use _errortxt
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
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
    if (_isStatusLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_statusError != null) {
      return Center(
        child: Text(
          _statusError!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (_historyItems.isEmpty) {
      return const Center(
        child: Text(
          "No items requested yet",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Data is loaded, display the list using _historyItems
    return Column(
      children: _historyItems
          .map((item) => _buildStatusItemCard(item)) // Pass HistoryItem
          .toList(),
    );
  }

 Widget _buildStatusItemCard(HistoryItem item) {
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
                // ✅ FIX 1: Use item.assetName
                "Name: ${item.assetName}",
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
              SizedBox(
                width: 100,
                height: 100,
                // ✅ FIX 2: Use item.image
                // This uses the image path from the HistoryItem
                child: Image.asset(item.image ?? 'assets/placeholder.png'),
                // Note: If your image path is a URL, use Image.network()
              ),
              const SizedBox(width: 8), // Added space
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
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              // ✅ FIX 3: Use the dynamic status from your model
              item.statusString,
              style: TextStyle(
                color: item.statusColor, // and the dynamic color
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

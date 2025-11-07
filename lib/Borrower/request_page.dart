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
      print(response.body);
      if (response.statusCode == 200) {
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
    final url = Uri.parse('http://10.0.2.2:3000/update-storage');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': itemId,
          'status': 'Pending',
          'assetID': itemId,
          'borrowDate': borrowDate.toIso8601String(),
          'returnDate': returnDate.toIso8601String(),
          'borrowBy': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Update successful!');
        print('Response body: ${response.body}');
        return true;
      } else {
        print('Failed to update status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _errortxt = response.body;
        });
        return false;
      }
    } catch (e) {
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
      _fetchStatusRequests(userId);
    } else {
      setState(() {
        _isStatusLoading = false;
        _statusError = "User not logged in.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 80;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: bottomPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabs(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF48A8A).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF48A8A).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFFF48A8A),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "You can only request once a day.",
                              style: TextStyle(
                                color: const Color(0xFFF48A8A),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _selectedTabIndex == 0
                          ? _buildAllRequestCards()
                          : _buildStatusCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? LightBrown : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: LightBrown.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4A3831),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllRequestCards() {
    if (_pendingItem == null) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No item selected",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }
    return _buildRequestInfoCard(_pendingItem!);
  }

  Widget _buildRequestInfoCard(RequestItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LightBrown, LightBrown.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildDeviceImage(item),
              const SizedBox(width: 20),
              _buildDeviceInfo(item),
            ],
          ),
          const SizedBox(height: 24),
          _buildDateField("Borrow", _borrowDate),
          const SizedBox(height: 16),
          _buildDateField("Return", _returnDate),
          const SizedBox(height: 24),
          _buildRequestButton(item),
        ],
      ),
    );
  }

  Widget _buildDeviceImage(RequestItem item) {
    return Container(
      decoration: BoxDecoration(
        color: DarkBrown,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DarkBrown.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFADDB9),
          borderRadius: BorderRadius.circular(16),
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "ID: ${item.id}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFE2F0D9), const Color(0xFFD4E8C7)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5A8E41).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A8E41),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item.status,
                  style: const TextStyle(
                    color: Color(0xFF5A8E41),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
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
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE9D3),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DarkBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: DarkBrown,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  DateFormat('d/M/yyyy').format(date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3831),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestButton(RequestItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DarkBrown.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: DarkBrown,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
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
              if (_userId != null) {
                _fetchStatusRequests(_userId!);
              }

              setState(() {
                _pendingItem = null;
                _selectedTabIndex = 1;
              });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text("${item.name} added to Request List"),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF5A8E41),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_errortxt ?? "Request failed")),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Request now",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LightBrown,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: LightBrown, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    if (_isStatusLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        ),
      );
    }

    if (_statusError != null) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              _statusError!,
              style: TextStyle(color: Colors.red.shade300, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    // 🟤 กรองเฉพาะรายการที่ยังไม่ถูก Approve หรือ Reject
    final activeItems = _historyItems
        .where(
          (item) =>
              item.displayStatus != "Approved" &&
              item.displayStatus != "Rejected",
        )
        .toList();

    if (activeItems.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.history, size: 64, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              "No items requested yet",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    return Container(
      height: 280,
      child: RefreshIndicator(
        color: DarkBrown,
        backgroundColor: Colors.white,
        onRefresh: () async {
          if (_userId != null && _userId!.isNotEmpty) {
            await _fetchStatusRequests(_userId!);
          }
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: activeItems.length,
          itemBuilder: (context, index) {
            final item = activeItems[index];
            return _buildStatusItemCard(item);
          },
        ),
      ),
    );
  }

  Widget _buildStatusItemCard(HistoryItem item) {
    if (item.displayStatus == "Approved" || item.displayStatus == "Rejected") {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DarkBrown.withOpacity(0.3), DarkBrown.withOpacity(0.2)],
        ),
        border: Border.all(color: LightBrown, width: 3),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "ID: ${item.id}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.assetName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.asset(
                    item.image ?? 'assets/placeholder.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: item.statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: item.statusColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.displayStatus == "Pending"
                        ? Icons.schedule
                        : Icons.check_circle_outline,
                    color: item.statusColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.displayStatus,
                    style: TextStyle(
                      color: item.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
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
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: LightBrown,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: const Color(0xFF4A3831),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/BottomBar.dart';

import 'package:project_mobile/Borrower/history_item.dart';
import 'package:intl/intl.dart';

class HomeStaff extends StatefulWidget {
  final int userId;

  const HomeStaff({super.key, required this.userId});

  @override
  State<HomeStaff> createState() => _HomeStaffState();
}

class _HomeStaffState extends State<HomeStaff> {
  int _selectedTabIndex = 0;
  List<dynamic> _assets = [];
  List<HistoryItem> _historyItems = [];
  bool _isLoadingAssets = true;
  bool _isLoadingHistory = true;
  String _searchQuery = "";
  String _searchHistoryQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchAssets();
    _fetchHistory();
  }

  Future<void> _fetchAssets([String query = ""]) async {
    try {
      final url = Uri.parse("http://10.0.2.2:3000/storage?q=$query");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _assets = json.decode(res.body);
          _isLoadingAssets = false;
        });
      } else {
        setState(() => _isLoadingAssets = false);
      }
    } catch (e) {
      print("Error fetching assets: $e");
      setState(() => _isLoadingAssets = false);
    }
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoadingHistory = true);
    final search = _searchHistoryQuery.trim();
    final url = Uri.parse("http://10.0.2.2:3000/history-all?search=$search");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List<dynamic> rawData = json.decode(res.body);
      setState(() {
        _historyItems = rawData
            .map((json) => HistoryItem.fromJson(json))
            .toList();
        _isLoadingHistory = false;
      });
    } else {
      setState(() => _isLoadingHistory = false);
    }
  }

  String _formatThaiDate(DateTime date) {
    print(date.year + 543);
    return "${date.day}/${date.month}/${date.year + 543}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(children: [Expanded(child: _buildTabs())]),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _selectedTabIndex == 0
                    ? (_isLoadingAssets ? _loadingUI() : _assetListFromAPI())
                    : _history(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingUI() =>
      const Center(child: CircularProgressIndicator(color: Color(0xFF8B5B46)));

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [_buildTabItem("All Assets", 0), _buildTabItem("History", 1)],
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
            color: isActive ? const Color(0xFFF6C68E) : Colors.white,
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

  Widget _assetListFromAPI() {
    final filteredAssets = _assets.where((item) {
      final name = item['Name']?.toString().toLowerCase() ?? '';
      final id = item['ID']?.toString() ?? '';
      final status = item['Status']?.toString() ?? '';

      return (name.contains(_searchQuery) || id.contains(_searchQuery)) &&
          status == "Available";
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8B5B46),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: [
          _buildSearchBar(
            onChanged: (value) {
              setState(() => _searchQuery = value.toLowerCase());
              _fetchAssets(value);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF8B5B46),
              onRefresh: () async => await _fetchAssets(_searchQuery),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: filteredAssets.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            "No items found.",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: filteredAssets.length,
                        itemBuilder: (context, index) {
                          final asset = filteredAssets[index];
                          return AssetCard(
                            name: asset['Name'],
                            id: asset['ID']?.toString() ?? '',
                            imagePath:
                                "assets/images/${asset['imageName'] ?? 'placeholder.png'}",
                            status: asset['Status'],
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar({required ValueChanged<String> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search by Name or Date and etc..",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _history() {
    final filteredHistory = _historyItems.where((item) {
      final query = _searchHistoryQuery.toLowerCase();
      final formattedBorrowDate = DateFormat('dd/MM/yyyy').format(
        DateTime(
          item.borrowDate.year + 543,
          item.borrowDate.month,
          item.borrowDate.day,
        ),
      );

      final formattedReturnDate = DateFormat('dd/MM/yyyy').format(
        DateTime(
          item.returnDate.year + 543,
          item.returnDate.month,
          item.returnDate.day,
        ),
      );

      final formattedActualReturnDate = item.actualReturnDate != null
          ? DateFormat('dd/MM/yyyy').format(
              DateTime(
                item.actualReturnDate!.year + 543,
                item.actualReturnDate!.month,
                item.actualReturnDate!.day,
              ),
            )
          : "";
      return item.assetName.toLowerCase().contains(query) ||
          (item.id?.toString().contains(query) ?? false) ||
          (item.borrowerName?.toLowerCase().contains(query) ?? false) ||
          (item.approverName?.toLowerCase().contains(query) ?? false) ||
          (item.receiverName?.toLowerCase().contains(query) ?? false) ||
          (item.rejecterName?.toLowerCase().contains(query) ?? false) ||
          (item.rejectReason?.toLowerCase().contains(query) ?? false) ||
          (item.displayStatus.toLowerCase().contains(query)) ||
          formattedBorrowDate.contains(query) ||
          formattedReturnDate.contains(query) ||
          formattedActualReturnDate.contains(query);
    }).toList();

    return Card(
      color: const Color(0xFF8B5B46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(
              onChanged: (value) async {
                setState(() => _searchHistoryQuery = value);
                await _fetchHistory();
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF8B5B46),
                onRefresh: () async {
                  await _fetchHistory();
                },
                child: _isLoadingHistory
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: filteredHistory.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    "No History found",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredHistory.length,
                                itemBuilder: (context, index) {
                                  final item = filteredHistory[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: _buildHistoryCard(item: item),
                                  );
                                },
                              ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({required HistoryItem item}) {
    const cardTop = Color(0xFFF8D49C); // ครีมส้มอ่อน
    const cardBottom = Color(0xFFF6C68E); // ส้มพีชแบบในรูป
    const darkBrown = Color(0xFF4A3831); // น้ำตาลตัวหนังสือ
    const imageBg = Color(0xFFF9E5C9); // พื้นหลังรูปอุปกรณ์

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFEC785), Color(0xFFFEC785).withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header ID + Asset Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${item.id.toString()}",
                style: const TextStyle(
                  color: darkBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              _CheckStatus(item.displayStatus),
              Flexible(
                child: Text(
                  item.assetName,
                  style: const TextStyle(
                    color: darkBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Image + Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูป
              Container(
                decoration: BoxDecoration(
                  color: imageBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  item.image ?? 'assets/images/placeholder.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateText("Borrowed Date"),
                          const SizedBox(height: 25),
                          _buildDateText("Returned Date"),
                          if (item.actualReturnDate != null)
                            const SizedBox(height: 25),
                          if (item.actualReturnDate != null)
                            _buildDateText("ActualReturn Date	"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateBox(_formatThaiDate(item.borrowDate)),
                          const SizedBox(height: 10),
                          _buildDateBox(_formatThaiDate(item.returnDate)),
                          if (item.actualReturnDate != null)
                            const SizedBox(height: 10),
                          if (item.actualReturnDate != null)
                            _buildDateBox(
                              item.actualReturnDate != null
                                  ? _formatThaiDate(item.actualReturnDate!)
                                  : "-",
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Approver / Receiver / Rejecter / Reason
          if (item.borrowerName != null)
            _buildInfoLine(
              icon: Icons.people_outline,
              text: "Borrower Name : ${item.borrowerName}",
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          if (item.approverName != null)
            _buildInfoLine(
              icon: Icons.check_circle_outline,
              text: "Approved by : ${item.approverName}",
              color: Colors.green.shade800,
            ),
          if (item.receiverName != null)
            _buildInfoLine(
              icon: Icons.person_outline,
              text: "Received by : ${item.receiverName}",
              color: Colors.blue.shade700,
            ),
          if (item.rejecterName != null)
            _buildInfoLine(
              icon: Icons.cancel_outlined,
              text: "Rejected by : ${item.rejecterName}",
              color: Colors.red.shade700,
            ),
          if (item.rejectReason != null)
            _buildInfoLine(
              icon: Icons.error_outline,
              text: "Reason : ${item.rejectReason}",
              color: Colors.redAccent.shade700,
            ),
        ],
      ),
    );
  }

  // ================== Date Box (ให้เข้ากับการ์ดใหม่) ==================
  Widget _buildDateBox(String date) {
    const darkBrown = Color(0xFF8B5B46);
    const db = Color(0xFF4A3831);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9E5C9),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: db, size: 14),
              SizedBox(width: 6),
              Text(date, style: const TextStyle(color: db, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateText(String label) {
    const darkBrown = Color(0xFF8B5B46);
    const db = Color(0xFF4A3831);

    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: darkBrown,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _buildInfoLine({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _CheckStatus(String Status) {
    Color bgColor = const Color(0xFFF9E5C9);
    Color textColor = const Color(0xFF4A3831);
    IconData iconData = Icons.calendar_today;

    switch (Status) {
      case "Approved":
        bgColor = Colors.green.shade100;
        textColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case "Rejected":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        iconData = Icons.book;
        break;
      case "Returned":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        iconData = Icons.hourglass_bottom;
        break;
      case "Disabled":
        bgColor = Colors.grey.shade300;
        textColor = Colors.grey.shade700;
        iconData = Icons.cancel;
        break;
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: textColor, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 18, color: textColor),
              SizedBox(width: 6),
              Text(
                Status,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _Borrowby(String Name) {
    Color bgColor = const Color(0xFFF9E5C9);
    Color textColor = const Color(0xFF4A3831);
    IconData iconData = Icons.man;

    return Row(
      children: [
        Text(
          "Borrowed by",
          style: TextStyle(
            color: Color(0xFF8B5B46),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 10),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 18, color: textColor),
              SizedBox(width: 6),
              Text(
                Name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ... (โค้ด _buildDateTag และ AssetCard ไม่ต้องแก้) ...
}

class AssetCard extends StatelessWidget {
  final String name;
  final String id;
  final String imagePath;
  final String status;

  const AssetCard({
    super.key,
    required this.name,
    required this.id,
    required this.imagePath,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2BE83),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: Image.asset(
                            imagePath,
                            height: 95,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ID: $id',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 244, 231),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: status == "Available"
                                ? Colors.green[600]
                                : Colors.red[600],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == "Available"
                                ? Colors.green[800]
                                : Colors.red[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

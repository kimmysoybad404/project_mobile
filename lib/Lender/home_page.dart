import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/BottomBar.dart';

// ✅ อ้างอิงจาก history_item.dart (ที่เราอัปเดตไปแล้ว)
import 'package:project_mobile/Borrower/history_item.dart';
import 'package:intl/intl.dart';

class HomeLender extends StatefulWidget {
  final int userId;

  const HomeLender({super.key, required this.userId});

  @override
  State<HomeLender> createState() => _HomeLenderState();
}

class _HomeLenderState extends State<HomeLender> {
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
        if (!mounted) return;
        setState(() => _isLoadingAssets = false);
      }
    } catch (e) {
      print("Error fetching assets: $e");
      if (!mounted) return;
      setState(() => _isLoadingAssets = false);
    }
  }

  Future<void> _fetchHistory() async {
    if (!mounted) return;
    setState(() => _isLoadingHistory = true);
    
    // ✅ 1. ลบ search query ออกจาก URL
    final url = Uri.parse(
      "http://10.0.2.2:3000/history/lender/${widget.userId}",
    );

    try { 
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> rawData = json.decode(res.body);
        if (!mounted) return;
        setState(() {
          _historyItems =
              rawData.map((json) => HistoryItem.fromJson(json)).toList();
          _isLoadingHistory = false;
        });
      } else {
        if (!mounted) return;
        setState(() => _isLoadingHistory = false);
      }
    } catch (e) {
      print("Error fetching lender history: $e");
      if (!mounted) return;
      setState(() => _isLoadingHistory = false);
    }
  }

  String _formatThaiDate(DateTime date) {
    // .toLocal() ถูกย้ายไปทำใน history_item.dart แล้ว
    // (แต่เผื่อไว้ก็ไม่เสียหายครับ)
    final localDate = date.toLocal(); 
    return "${localDate.day}/${localDate.month}/${localDate.year + 543}";
  }

  @override
  Widget build(BuildContext context) {
    // (โค้ดส่วนนี้เหมือนเดิม)
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
    // (โค้ดส่วนนี้เหมือนเดิม)
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabItem("Browse asset list", 0),
          _buildTabItem("History", 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    // (โค้ดส่วนนี้เหมือนเดิม)
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
    // (โค้ดส่วนนี้เหมือนเดิม)
    final filteredAssets = _assets.where((item) {
      final name = item['Name']?.toString().toLowerCase() ?? '';
      final id = item['ID']?.toString() ?? '';
      // (Lender ควรเห็นทุกสถานะ)
      return (name.contains(_searchQuery) || id.contains(_searchQuery));
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
                            _searchQuery.isEmpty
                                ? "No items found"
                                : "No items found for '$_searchQuery'",
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
    // (โค้ดส่วนนี้เหมือนเดิม)
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
                hintText: "Search by Name or ID...",
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
    // 1. รับคำค้นหาดิบ (trim และ lowercase)
    final rawQuery = _searchHistoryQuery.trim().toLowerCase();

    final filteredHistory = _historyItems.where((item) {
      // --- 2. เตรียมข้อมูลทั้งหมดที่จะใช้ค้นหา ---
      
      // (วันที่แบบ AD)
      final borrowDateAD = DateFormat('dd/MM/yyyy').format(item.borrowDate);
      final returnDateAD = DateFormat('dd/MM/yyyy').format(item.returnDate);
      final actualReturnDateAD = item.actualReturnDate != null
          ? DateFormat('dd/MM/yyyy').format(item.actualReturnDate!)
          : "";

      // (วันที่แบบ BE - พ.ศ.)
      final borrowDateBE = "${item.borrowDate.day}/${item.borrowDate.month}/${item.borrowDate.year + 543}";
      final returnDateBE = "${item.returnDate.day}/${item.returnDate.month}/${item.returnDate.year + 543}";
      final actualReturnDateBE = item.actualReturnDate != null
          ? "${item.actualReturnDate!.day}/${item.actualReturnDate!.month}/${item.actualReturnDate!.year + 543}"
          : "";
          
      // (ข้อมูล Text อื่นๆ)
      final assetID = item.assetID.toString().toLowerCase();
      final assetName = item.assetName.toLowerCase();
      final borrowerName = (item.borrowerName ?? '').toLowerCase();
      final receiver = (item.receiverName ?? '').toLowerCase();
      final status = item.displayStatus.toLowerCase();
      final id = item.id.toString();

      // --- 3. ตรวจสอบ Prefix (คำนำหน้า) ---

      if (rawQuery.startsWith("borrow:")) {
        final query = rawQuery.substring(7).trim(); // เอาข้อความหลัง "borrow:"
        return borrowDateAD.contains(query) || borrowDateBE.contains(query);
      }
      
      if (rawQuery.startsWith("return:")) {
        final query = rawQuery.substring(7).trim(); // เอาข้อความหลัง "return:"
        return returnDateAD.contains(query) || returnDateBE.contains(query);
      }

      if (rawQuery.startsWith("actual:")) {
        final query = rawQuery.substring(7).trim(); // เอาข้อความหลัง "actual:"
        return actualReturnDateAD.contains(query) || actualReturnDateBE.contains(query);
      }
      
      if (rawQuery.startsWith("status:")) {
        final query = rawQuery.substring(7).trim(); // เอาข้อความหลัง "status:"
        return status.contains(query);
      }

      if (rawQuery.startsWith("by:")) {
        final query = rawQuery.substring(3).trim(); // เอาข้อความหลัง "by:"
        return borrowerName.contains(query) || receiver.contains(query);
      }

      // --- 4. ถ้าไม่มี Prefix: ค้นหาทุกช่อง (แบบเดิม) ---
      return id.contains(rawQuery) ||
          assetID.contains(rawQuery) ||
          assetName.contains(rawQuery) ||
          borrowerName.contains(rawQuery) ||
          receiver.contains(rawQuery) ||
          status.contains(rawQuery) ||
          borrowDateAD.contains(rawQuery) ||
          returnDateAD.contains(rawQuery) ||
          actualReturnDateAD.contains(rawQuery) ||
          borrowDateBE.contains(rawQuery) ||
          returnDateBE.contains(rawQuery) ||
          actualReturnDateBE.contains(rawQuery);
          
    }).toList();
  
    // (ส่วน UI ของ _history() ที่เหลือเหมือนเดิม)
    return Card(
      color: const Color(0xFF8B5B46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchHistoryQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoadingHistory
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF8B5B46),
                      onRefresh: _fetchHistory,
                      child: filteredHistory.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 40),
                                  Icon(
                                    Icons.history,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchHistoryQuery.isEmpty
                                      ? "No history found"
                                      : "No history found for '$_searchHistoryQuery'",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredHistory.length,
                              itemBuilder: (context, index) {
                                final item = filteredHistory[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: _buildHistoryCard(item: item),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // ✅✅✅ === 1. อัปเดต _buildHistoryCard() === ✅✅✅
  //
  Widget _buildHistoryCard({required HistoryItem item}) {
    const darkBrown = Color(0xFF4A3831); 
    const imageBg = Color(0xFFF9E5C9); 
    const accentBrown = Color(0xFF8B5B46);

    return Container(
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
          Row(
            // ... (ID and Status) ...
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${item.id.toString().padLeft(5, '0')}",
                style: const TextStyle(
                  color: darkBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              _CheckStatus(item.displayStatus),
            ],
          ),
          Padding(
            // ... (Asset Name) ...
            padding: const EdgeInsets.only(top: 8.0),
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
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // ... (Image) ...
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
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 90, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateText("Borrowed Date"),
                          const SizedBox(height: 25),
                          _buildDateText("Returned Date"),
                          const SizedBox(height: 25),
                          if (item.actualReturnDate != null)
                            _buildDateText("ActualReturn Date"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateBox(_formatThaiDate(item.borrowDate)),
                          const SizedBox(height: 10),
                          _buildDateBox(_formatThaiDate(item.returnDate)),
                          const SizedBox(height: 10),

                          //
                          // ✅✅✅ === แก้ไขตรงนี้ === ✅✅✅
                          //
                          if (item.actualReturnDate != null)
                            _buildDateBox(
                              _formatThaiDate(item.actualReturnDate!),
                              // ❌ ลบ tagColor: Colors.orange[300]! ออก
                              // เพื่อให้มันใช้สี default (สีครีม)
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
          
          // ... (Info lines: Borrower, Receiver, etc. - เหมือนเดิม) ...
          if (item.borrowerName != null)
            _buildInfoLine(
              icon: Icons.person_pin,
              text: "Borrow by : ${item.borrowerName}",
              color: accentBrown,
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
          if (item.rejectReason != null && item.rejectReason!.isNotEmpty)
            _buildInfoLine(
              icon: Icons.error_outline,
              text: "Reason : ${item.rejectReason}",
              color: Colors.redAccent.shade700,
            ),
        ],
      ),
    );
  }

  //
  // ✅✅✅ === 4. อัปเดต _buildDateBox() (เพิ่ม tagColor) === ✅✅✅
  //
  Widget _buildDateBox(String date, {Color tagColor = const Color(0xFFF9E5C9)}) { // 1. เพิ่ม tagColor
    const db = Color(0xFF4A3831);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: tagColor, // 2. ใช้ tagColor
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
    // (โค้ดส่วนนี้เหมือนเดิม)
    const darkBrown = Color(0xFF8B5B46);
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
    // (โค้ดส่วนนี้เหมือนเดิม)
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
    // (โค้ดส่วนนี้เหมือนเดิม)
    Color bgColor = const Color(0xFFF9E5C9);
    Color textColor = const Color(0xFF4A3831);
    IconData iconData = Icons.hourglass_empty; 

    switch (Status.toLowerCase()) { 
      case "approved":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800; 
        iconData = Icons.check_circle;
        break;
      case "rejected":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        iconData = Icons.cancel; 
        break;
      case "returned":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        iconData = Icons.assignment_returned; 
        break;
      case "disabled":
        bgColor = Colors.grey.shade300;
        textColor = Colors.grey.shade700;
        iconData = Icons.do_not_disturb;
        break;
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: textColor, width: 1.5), 
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, size: 16, color: textColor), 
              SizedBox(width: 6),
              Text(
                Status,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// (AssetCard Class - ไม่มีการเปลี่ยนแปลงจากครั้งก่อน)
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
                                : (status == "Pending" ? Colors.orange[600] : Colors.red[600]), // ✅ อัปเดตสี
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == "Available"
                                ? Colors.green[800]
                                : (status == "Pending" ? Colors.orange[800] : Colors.red[800]), // ✅ อัปเดตสี
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
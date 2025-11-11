import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/BottomBar.dart';
// import 'request_page.dart'; // ไม่ได้ใช้ request_page.dart โดยตรง
import 'request_item.dart';
import 'history_item.dart'; // 1. ✅ Import history_item.dart
import 'package:intl/intl.dart';

class HomeBorrower extends StatefulWidget {
  // 2. ✅ เพิ่ม userId เข้ามา
  final int userId;

  const HomeBorrower({
    super.key,
    required this.userId, // 3. ✅ ทำให้เป็น required
  });

  @override
  State<HomeBorrower> createState() => _HomeBorrowerState();
}

class _HomeBorrowerState extends State<HomeBorrower> {
  int _selectedTabIndex = 0;
  List<RequestItem> _requestedItems = [];
  List<dynamic> _assets = [];
  bool _isLoadingAssets = true; // 4. ✅ แยก state การ loading
  String _searchQuery = "";

  // 5. ✅ เพิ่ม state สำหรับ History
  List<HistoryItem> _historyItems = [];
  bool _isLoadingHistory = true;
  String _searchHistoryQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchAssets();
    _fetchHistory(); // 6. ✅ เรียกดึงข้อมูล history ตอนเริ่ม
  }

  Future<void> _fetchAssets([String query = ""]) async {
    try {
      // 1. ✅ แก้ URL ให้รับ query
      final url = Uri.parse("http://10.0.2.2:3000/storage?q=$query");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        if (!mounted) return; // 2. ✅ เพิ่ม check mounted
        setState(() {
          _assets = json.decode(res.body);
          _isLoadingAssets = false;
        });
      } else {
        print("Failed to fetch assets: ${res.statusCode}");
        if (!mounted) return; // 3. ✅ เพิ่ม check mounted
        setState(() => _isLoadingAssets = false);
      }
    } catch (e) {
      print("Error: $e");
      if (!mounted) return; // 4. ✅ เพิ่ม check mounted
      setState(() => _isLoadingAssets = false);
    }
  }

  Future<void> _fetchHistory() async {

    if (!mounted) return; 
    setState(() => _isLoadingHistory = true);

    try {
      final search = _searchHistoryQuery.trim();
      final url = Uri.parse(
        "http://10.0.2.2:3000/history/${widget.userId}?search=$search",
      );
      final res = await http.get(url);

      if (!mounted) return; 
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
        debugPrint("Failed to fetch history: ${res.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("Error fetching history: $e");
      setState(() => _isLoadingHistory = false);
    }
  }

  // 9. ✅ ฟังก์ชันช่วยแปลงวันที่ให้เป็น "วัน/เดือน/ปี(พ.ศ.)"
  String _formatThaiDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year + 543}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                    : _history(), // 10. ✅ สลับไปที่ _history()
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
        children: [
          _buildTabItem("Browse asset list", 0),
          _buildTabItem("History", 1),
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

      // ✅ ค้นหาได้ทั้งชื่อและไอดี
      final matchesQuery =
          name.contains(_searchQuery) || id.contains(_searchQuery);

      // ✅ ต้องมีสถานะ Available และตรงกับคำค้นหา
      return status == 'Available' && matchesQuery;
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
              setState(() {
                _searchQuery = value.toLowerCase();
              });
              _fetchAssets(
                value.isEmpty ? "" : value,
              ); // ✅ ป้องกัน error ตอนค้นหา
            },
          ),

          const SizedBox(height: 10),

          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF8B5B46),
              onRefresh: () async {
                await _fetchAssets(_searchQuery);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (filteredAssets.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            _searchQuery.isEmpty
                                ? "No available items right now or No items found for '$_searchQuery'"
                                : "No available items right now or No items found for '$_searchQuery'",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
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
                          final name = asset['Name'] ?? 'Unknown';
                          final id = asset['ID']?.toString() ?? '';
                          final imageName =
                              asset['imageName'] ?? 'placeholder.png';
                          final status = asset['Status'] ?? 'Unknown';

                          return AssetCard(
                            name: name,
                            id: id,
                            imagePath: "assets/images/$imageName",
                            status: status,
                            onAdd: _addItem,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addItem(String id, String name, String imagePath) {
    final newItem = RequestItem(
      id: id,
      name: name,
      image: imagePath,
      borrowDate: DateTime.now(),
      returnDate: DateTime.now().add(const Duration(days: 3)),
      status: 'Pending',
    );

    // ถ้าต้องการใช้ชื่อ user ที่ login อยู่ ต้องส่ง username มาให้ HomeBorrower ด้วย
    // แล้วเปลี่ยน 'username: name' เป็น 'username: widget.username'
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomBar(
          role: 1,
          username: name, // <-- นี่คือชื่อ asset
          newItem: newItem,
          //`
          // ⭐️⭐️⭐️ FIX: แก้จาก userId: เป็น userid: ⭐️⭐️⭐️
          //
          userid: widget.userId,
        ),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$name added to request list ✅")));
  }

  Widget _buildSearchBar({required ValueChanged<String> onChanged}) {
    // 11. ✅ แก้ไข _buildSearchBar ให้รับ onChanged
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
              onChanged: onChanged, // 12. ✅ ใช้งาน onChanged ที่รับเข้ามา
            ),
          ),
        ],
      ),
    );
  }

  // 13. ✅ ============ แก้ไข Widget _history() ทั้งหมด ============
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
      
      // ✅ (Borrower) จะค้นหาชื่อผู้ อนุมัติ/รับ/ปฏิเสธ
      final approver = (item.approverName ?? '').toLowerCase();
      final receiver = (item.receiverName ?? '').toLowerCase();
      final rejecter = (item.rejecterName ?? '').toLowerCase();
      
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

      // ✅ (Borrower) ค้นหา "by:" จะหาจาก (approver, receiver, rejecter)
      if (rawQuery.startsWith("by:")) {
        final query = rawQuery.substring(3).trim(); // เอาข้อความหลัง "by:"
        return approver.contains(query) || receiver.contains(query) || rejecter.contains(query);
      }

      // --- 4. ถ้าไม่มี Prefix: ค้นหาทุกช่อง (แบบเดิม) ---
      return id.contains(rawQuery) ||
          assetID.contains(rawQuery) ||
          assetName.contains(rawQuery) ||
          approver.contains(rawQuery) ||
          receiver.contains(rawQuery) ||
          rejecter.contains(rawQuery) ||
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
              child: RefreshIndicator(
                color: Color(0xFF8B5B46),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                onRefresh: _fetchHistory,
                child: _isLoadingHistory
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF8B5B46),
                        ),
                      )
                    : filteredHistory.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 100),
                          Icon(Icons.history, size: 64, color: Colors.white),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              "No History Naja",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
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

  // ================== History Card ==================
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
        children: [
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
                          // ✅ 1. เพิ่มการตรวจสอบ (ถ้ามีวันที่คืนจริงค่อยแสดง)
                          if (item.actualReturnDate != null) ...[
                            const SizedBox(height: 25),
                          _buildDateText("ActualReturn Date"),
                          ]
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateBox(_formatThaiDate(item.borrowDate)),
                          const SizedBox(height: 10),
                          _buildDateBox(_formatThaiDate(item.returnDate)),
                          const SizedBox(height: 10),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 15,
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

  // ... (โค้ด _buildDateTag และ AssetCard ไม่ต้องแก้) ...
}

class AssetCard extends StatelessWidget {
  // ... (โค้ด AssetCard ไม่ต้องแก้) ...
  final String name;
  final String id;
  final String imagePath;
  final String status;
  final Function(String, String, String) onAdd;

  const AssetCard({
    super.key,
    required this.name,
    required this.id,
    required this.imagePath,
    required this.status,
    required this.onAdd,
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
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onAdd(id, name, imagePath),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 22,
                              color: Color(0xFFF2BE83),
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

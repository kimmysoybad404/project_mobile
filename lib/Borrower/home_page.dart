import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/BottomBar.dart';
// import 'request_page.dart'; // ไม่ได้ใช้ request_page.dart โดยตรง
import 'request_item.dart';
import 'history_item.dart'; //Import history_item.dart

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


  // 8. ✅ ฟังก์ชันใหม่สำหรับดึงข้อมูล History
  Future<void> _fetchHistory() async {
    if (!mounted) return;
    setState(() => _isLoadingHistory = true);

    try {
      // 🚨 ตรวจสอบให้แน่ใจว่า widget.userId มีค่าที่ถูกต้อง
      final url = Uri.parse("http://10.0.2.2:3000/history/${widget.userId}");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> rawData = json.decode(res.body);
        setState(() {
          _historyItems =
              rawData.map((json) => HistoryItem.fromJson(json)).toList();
          _isLoadingHistory = false;
        });
      } else {
        print("Failed to fetch history: ${res.statusCode}");
        setState(() => _isLoadingHistory = false);
      }
    } catch (e) {
      print("Error fetching history: $e");
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
    final filteredAssets = _assets
        .where(
          (item) =>
              item['Status'] == 'Available' &&
              item['Name'].toString().toLowerCase().contains(_searchQuery),
        )
        .toList();

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
            },
          ),
          const SizedBox(height: 10),
          if (filteredAssets.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? "No availible items right now"
                      : "No items found for '$_searchQuery'",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                      final name = asset['Name'];
                      final id = asset['ID'].toString();
                      final imageName = asset['imageName'];
                      final status = asset['Status'];

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
            //
            // ⭐️⭐️⭐️ FIX: แก้จาก userId: เป็น userid: ⭐️⭐️⭐️
            //
            userid: widget.userId),
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
                hintText: "search here...",
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
    // 14. ✅ กรองผลลัพธ์ตามการค้นหา
    final filteredHistory = _historyItems
        .where(
          (item) =>
              item.assetName
                  .toLowerCase()
                  .contains(_searchHistoryQuery.toLowerCase()) ||
              item.id
                  .toString()
                  .padLeft(5, '0')
                  .contains(_searchHistoryQuery.toLowerCase()),
        )
        .toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5B46),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
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
                ? _loadingUI() // 15. ✅ แสดง loading
                : filteredHistory.isEmpty
                    ? Center(
                        // 16. ✅ แสดงผลเมื่อไม่พบข้อมูล
                        child: Text(
                          _searchHistoryQuery.isEmpty
                              ? "No history found."
                              : "No history found for '$_searchHistoryQuery'",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : RefreshIndicator(
                        // 17. ✅ เพิ่ม RefreshIndicator
                        onRefresh: _fetchHistory,
                        color: Color(0xFF8B5B46),
                        child: ListView.builder(
                          key: const PageStorageKey(
                              'historyList'), // 18. ✅ ใช้ ListView.builder
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: filteredHistory.length,
                          itemBuilder: (context, index) {
                            final item = filteredHistory[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildHistoryCard(
                                  item: item), // 19. ✅ ส่ง HistoryItem ทั้งก้อน
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({required HistoryItem item}) {
    // 21. ✅ รับเป็น HistoryItem
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF6C68E), width: 5.0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // ... (ส่วนแสดง ID และ Name เหมือนเดิม) ...
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: ${item.id.toString().padLeft(5, '0')}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Name: ${item.assetName}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            // ... (ส่วนแสดง รูปภาพ และ วันที่ เหมือนเดิม) ...
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item.image ?? 'assets/images/placeholder.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateTag('Borrow', _formatThaiDate(item.borrowDate)),
                  const SizedBox(height: 10),
                  _buildDateTag('Return', _formatThaiDate(item.returnDate)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          //  status
          _buildInfoBar(
            'Status: ${item.displayStatus}',
            backgroundColor: item.statusColor,
            textColor: item.displayStatus.toLowerCase() == 'pending'
                ? Colors.black87
                : Colors.white,
          ),

          //  ApproveBy (ถ้ามี)
          if (item.approverName != null) ...[
            const SizedBox(height: 10),
            _buildInfoBar('Approve by: ${item.approverName}'),
          ],

          //  ReceiveBy (ถ้ามี)
          if (item.receiverName != null) ...[
            const SizedBox(height: 10),
            _buildInfoBar('Received asset by: ${item.receiverName}'),
          ],

          
          //  แสดง "ผู้ปฏิเสธ" 
          
          if (item.rejecterName != null) ...[
            const SizedBox(height: 10),
            _buildInfoBar(
              'Reject by: ${item.rejecterName}',
            ),
          ],
          
         
          

          // แสดง "เหตุผลที่ Reject" (ถ้ามี)
          if (item.rejectReason != null) ...[
            const SizedBox(height: 10),
            _buildInfoBar('Reason: ${item.rejectReason}',
                backgroundColor: Colors.red.withOpacity(0.2),
                textColor: const Color.fromARGB(255, 255, 255, 255)),
          ],
        ],
      ),
    );
  }

  // 35. ✅ แก้ไข _buildInfoBar ให้รับสีได้
  Widget _buildInfoBar(
    String text, {
    Color backgroundColor = const Color(0xFFDCCFCC),
    Color? textColor = const Color(0xFF4A3831),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center, // 36. ✅ เผื่อข้อความยาว
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ... (โค้ด _buildDateTag และ AssetCard ไม่ต้องแก้) ...
  Widget _buildDateTag(String label, String date) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF6C68E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC80),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.black87, size: 18),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image_not_supported,
                                    color: Colors.grey[700]),
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
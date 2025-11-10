import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'request_item.dart';

class RequestPageLender extends StatefulWidget {
  const RequestPageLender({super.key});

  @override
  State<RequestPageLender> createState() => _RequestPageLenderState();
}

class _RequestPageLenderState extends State<RequestPageLender>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final Color DarkBrown = const Color(0xFF8B5B46);
  final Color LightBrown = const Color(0xFFFEC785);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final ApiService _apiService = ApiService();
  List<RequestItem> _requests = [];
  bool _isLoading = true;
  String _errorMessage = "";
  String? savedUsername;
  late final TextEditingController _searchController;
  String? _userId;

  // RequestPageLender.dart (ภายใน _RequestPageLenderState)

  // --- 1. ฟังก์ชันสำหรับแสดง Dialog ---
  Future<String?> _showRejectDialog() {
    // Controller สำหรับช่องกรอกข้อความ
    final TextEditingController reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // บังคับให้กดปุ่ม
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Rejection', style: TextStyle(color: LightBrown)),
          backgroundColor: DarkBrown, // สีพื้นหลังเดียวกับ Scaffold
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Please provide a reason for rejection:',
                  style: TextStyle(color: LightBrown),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  autofocus: true, // Focus ที่ช่องนี้เลย
                  decoration: InputDecoration(
                    hintText: "Enter reason here...",
                    hintStyle: TextStyle(color: LightBrown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: LightBrown, width: 2),
                    ),
                  ),
                  maxLines: 3, // ให้กรอกได้หลายบรรทัด
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // --- ปุ่ม Cancel ---
            TextButton(
              child: Text('Cancel', style: TextStyle(color: LightBrown)),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog โดยไม่ส่งค่า
              },
            ),

            // --- ปุ่ม Submit (Reject) ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF48A8A), // สีแดง (Reject)
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Submit Rejection'),
              onPressed: () {
                // TODO: อาจจะเพิ่มการตรวจสอบว่ากรอกเหตุผลหรือยัง
                if (reasonController.text.trim().isEmpty) {
                  // (Optional) แสดง Error ว่ายังไม่กรอก
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a reason."),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // ส่งเหตุผลกลับไป
                  Navigator.of(context).pop(reasonController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid') ?? '';
    setState(() {
      _userId = userId;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // --- เรียก API ตอนเริ่ม ---
    _fetchData();
    loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose(); // อย่าลืม dispose controller
    super.dispose();
  }

  // --- ฟังก์ชันสำหรับดึงข้อมูล ---
  Future<void> _fetchData({String query = ""}) async {
    setState(() {
      _isLoading = true; // เริ่มโหลด
      _errorMessage = "";
    });

    try {
      final requests = await _apiService.fetchPendingRequests(query: query);
      setState(() {
        _requests = requests;

        _isLoading = false; // โหลดเสร็จ
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false; // โหลดล้มเหลว
      });
    }
  }

  // --- ฟังก์ชันสำหรับ Approve/Reject ---
  Future<void> _approveRequest(String historyId) async {
    final String? currentLenderId = _userId;

    try {
      // 👇 ส่ง ID ทั้งสองตัวไปที่ service
      bool success = await _apiService.approveRequest(
        historyId,
        currentLenderId!,
      );

      if (success) {
        _fetchData(query: _searchController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Approved!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _rejectRequest(String historyId) async {
    final String? reason = await _showRejectDialog();

    if (reason == null || reason.isEmpty) {
      return;
    }

    final String? currentLenderId = _userId;

    try {
      bool success = await _apiService.rejectRequest(
        historyId,
        currentLenderId!,
        reason,
      );
      if (success) {
        _fetchData(query: _searchController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Rejected!"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: DarkBrown,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTabs(),
                      const SizedBox(height: 10),
                      _buildSearchBar(), // ปรับปรุง Search Bar
                      const SizedBox(height: 2),
                      IndexedStack(
                        index: _selectedTabIndex,
                        children: [
                          // --- ส่วนที่เปลี่ยน: แสดง Loading, Error, หรือ List ---
                          _buildDynamicContent(),
                        ],
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.all(5),
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
      child: Row(children: [_buildTabItem("Request", 0)]),
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
                      color: LightBrown.withOpacity(0.5),
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

  Widget _buildSearchBar() {
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
              controller: _searchController, // --- เชื่อม Controller ---
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "search here...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              // --- เมื่อพิมพ์เสร็จ (หรือ onChanged) ให้ค้นหา ---
              onSubmitted: (value) {
                _fetchData(query: value);
              },
              onChanged: (value) {
                // TODO: อาจจะเพิ่ม Debounce 500ms ที่นี่
                if (value.isEmpty) {
                  _fetchData(query: "");
                }
                // หรือจะให้ค้นหาทันทีที่พิมพ์ก็ได้
                // _fetchData(query: value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget ใหม่สำหรับจัดการ State ---
  Widget _buildDynamicContent() {
    if (_isLoading) {
      // --- 1. ขณะโหลด ---
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      // --- 2. เกิด Error ---
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "Error: $_errorMessage",
            style: const TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_requests.isEmpty) {
      // --- 3. ไม่มีข้อมูล ---
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            "No pending requests found.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    // --- 4. มีข้อมูล ---
    return _buildStatusCardList(_requests);
  }

  // --- ปรับปรุง _buildStatusCard ให้รับ List ---
  Widget _buildStatusCardList(List<RequestItem> requests) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final item = requests[index]; // --- ใช้ RequestItem Model ---
        return Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [LightBrown, LightBrown.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
                    "ID: ${item.id}", // --- ใช้ข้อมูลจาก Model ---
                    style: const TextStyle(
                      color: Color(0xFF4A3831),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Name: ${item.assetName}", // --- ใช้ข้อมูลจาก Model ---
                    style: const TextStyle(
                      color: Color(0xFF4A3831),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E5C9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      // --- ใช้ข้อมูลจาก Model ---
                      // API ควรคืนค่าแค่ 'notebook.png'
                      "assets/images/${item.image}",
                      width: 90,
                      height: 90,
                      // --- เพิ่ม Error Builder ---
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 90);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildDateBox("Borrower", item.borrowerName),
                        const SizedBox(height: 12),
                        _buildDateBox(
                          "Borrow",
                          item.borrowDate,
                        ), // --- ใช้ข้อมูลจาก Model ---
                        const SizedBox(height: 12),
                        _buildDateBox(
                          "Return",
                          item.returnDate,
                        ), // --- ใช้ข้อมูลจาก Model ---
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // --- ส่ง ID ไปให้ปุ่ม ---
              _buildStatusFooter(item.id),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateBox(String label, String date) {
    // ... (เหมือนเดิม) ...
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A3831),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9E5C9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF4A3831),
                ),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF4A3831),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFooter(String id) {
    // --- รับ ID มา ---
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            _buildSmallButton("Reject", const Color(0xFFF48A8A), () {
              // --- เรียกฟังก์ชัน Reject ---
              _rejectRequest(id);
            }),
            const SizedBox(width: 8),
            _buildSmallButton("Approve", const Color(0xFF90C695), () {
              // --- เรียกฟังก์ชัน Approve ---
              _approveRequest(id);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallButton(String text, Color color, VoidCallback onPressed) {
    // --- รับ OnPressed ---
    return ElevatedButton(
      onPressed: onPressed, // --- เชื่อมฟังก์ชัน ---
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

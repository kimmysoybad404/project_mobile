import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int _selectedTabIndex = 0;
  Color DarkBrown = const Color(0xFF8B5B46);
  Color LightBrown = const Color(0xFFFEC785);

  // --- CHANGED: ตั้งค่าเริ่มต้นให้เป็นวันปัจจุบันทั้งคู่ ---
  DateTime _borrowDate = DateTime.now();
  DateTime _returnDate = DateTime.now();

  // --- UPDATED: อัปเดตฟังก์ชันเลือกวันให้มีเงื่อนไขตามที่ต้องการ ---
  Future<void> _selectDate(BuildContext context, bool isBorrowDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBorrowDate ? _borrowDate : _returnDate,
      // เงื่อนไข: ถ้าเป็นวันยืม (Borrow) ให้เริ่มที่วันนี้, ถ้าเป็นวันคืน (Return) ให้เริ่มที่วันที่ยืม
      firstDate: isBorrowDate ? DateTime.now() : _borrowDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: DarkBrown,
              onPrimary: Colors.white,
              onSurface: DarkBrown,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: DarkBrown,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isBorrowDate) {
          _borrowDate = picked;
          // ถ้าวันยืมที่เลือกใหม่ อยู่หลังวันคืนปัจจุบัน ให้ปรับวันคืนเป็นวันเดียวกัน
          if (_borrowDate.isAfter(_returnDate)) {
            _returnDate = _borrowDate;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 585,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: DarkBrown,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabs(),
                    const SizedBox(height: 12),
                    const Text(
                      "*You can only request once a day.",
                      style: TextStyle(color: Color(0xFFF48A8A), fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    IndexedStack(
                      index: _selectedTabIndex,
                      children: [_buildRequestInfoCard(), _buildStatusCard()],
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
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
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

    Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          ElevatedButton( 
            onPressed: () {
              // ใส่ logic การค้นหาตรงนี้

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightBrown, 
              foregroundColor: const Color(0xFF4A3831),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
            child: Row(
              children: const [
                Icon(Icons.search, size: 18),
                SizedBox(width: 8),
                Text(
                  "Search",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "search here...", hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightBrown,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeviceImage(),
              const SizedBox(width: 16),
              _buildDeviceInfo(),
            ],
          ),
          const SizedBox(height: 16),
          _buildDateField("Borrow", _borrowDate, true),
          const SizedBox(height: 12),
          _buildDateField("Return", _returnDate, false),
          const SizedBox(height: 20),
          _buildRequestButton(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Column(
      children: [
        _buildStatusItem(),
      ],
    );
  }

  Widget _buildStatusItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: LightBrown,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ID: 00001",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Name: Notebook",
                style: TextStyle(
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
                child:
                    Container(width: 100,height: 100,child: Image.asset("assets/images/Notebook.png")),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildStatusDateRow("Borrow", "25/1/2568"),
                    const SizedBox(height: 12),
                    _buildStatusDateRow("Return", "25/1/2568"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                "Waiting for approve",
                style: TextStyle(
                  color: Color(0xFFF9E076),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
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
              mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildDeviceImage() {
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
          child: Image.asset("assets/images/Notebook.png"),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notebook",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            "ID:00001",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F0D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Status: Available",
              style: TextStyle(
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

  Widget _buildDateField(String label, DateTime date, bool isBorrowDate) {
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
              IconButton(
                icon: Icon(Icons.calendar_today_rounded, color: DarkBrown),
                onPressed: () {
                  _selectDate(context, isBorrowDate);
                },
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
              const SizedBox(width: 48), // To balance the IconButton space
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRequestButton() {
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
          // Handle request logic here
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
}


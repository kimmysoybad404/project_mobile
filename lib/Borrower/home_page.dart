import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomeBorrower extends StatefulWidget {
  const HomeBorrower({super.key});

  @override
  State<HomeBorrower> createState() => _HomeBorrowerState();
}

class _HomeBorrowerState extends State<HomeBorrower> {
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // --- Tab Buttons ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(children: [Expanded(child: _buildTabs())]),
              ),
            ),

            const SizedBox(height: 15),

            // --- Asset Cards Grid ---
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [_assetlist(), _history()],
              ),
            ),
          ],
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
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFFF6C68E) : Colors.white,
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

  //   Widget _assetlist() {
  //   )
  // }
  Widget _assetlist() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8B5B46),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          AssetCard(
            name: 'Notebook',
            id: '00001',
            imagePath: 'assets/images/notebook.png',
            status: 'Available',
          ),
          AssetCard(
            name: 'Ipad',
            id: '00002',
            imagePath: 'assets/images/ipad.png',
            status: 'Available',
          ),
          AssetCard(
            name: 'Board game',
            id: '00003',
            imagePath: 'assets/images/boardgame.png',
            status: 'Available',
          ),
          AssetCard(
            name: 'Power bank',
            id: '00004',
            imagePath: 'assets/images/powerbank.png',
            status: 'Available',
          ),
        ],
      ),
    );
    // ),
  }
}

Widget _history() {
  return Card(
    color: const Color(0xFF8B5B46),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // ✅ เพิ่มให้ scroll ได้ในกรณีข้อมูลยาว
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID + Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('ID: 0003', style: TextStyle(color: Colors.white)),
                Text('Name: Board game', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 10),

            // 🔸 ข้อมูลการยืม - คืน
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5B46),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูป
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF8B5B46),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/boardgame.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // ข้อมูลวันที่
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Borrow',
                            style: TextStyle(
                              color: Color(0xFFF6C68E),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 15),
                          _buildDateTag('25/1/2568'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text(
                            'Return',
                            style: TextStyle(
                              color: Color(0xFFF6C68E),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 15),
                          _buildDateTag('25/1/2568'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔸 ข้อมูลผู้อนุมัติและผู้รับทรัพย์
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE6E1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Approve by: Lender001',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF8B5B46),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE6E1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Received asset by: Staff001',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF8B5B46),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ✅ ตัวช่วยแสดงแท็กวันที่
Widget _buildDateTag(String date) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFFCC80),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.black87, size: 20),
        const SizedBox(width: 8),
        Text(
          date,
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ],
    ),
  );
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

  // @override

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2BE83),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image & Add Button ----------------------------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(imagePath, height: 90),

              // ✅ ขยับปุ่ม + ขึ้นเล็กน้อย
              Transform.translate(
                offset: const Offset(0, -30), // ปรับ -8 หรือ -10 แล้วแต่ต้องการ
                child: const Icon(Icons.add, size: 26, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            'ID:$id',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Status: ',
                    // style: TextStyle(color: Colors.black87, fontSize: 12),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: status,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(221, 17, 172, 51),
                      fontSize: 12,
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
}

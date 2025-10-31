import 'package:flutter/material.dart';
import 'package:project_mobile/BottomBar.dart';
import 'request_page.dart';
import 'request_item.dart'; // เพิ่ม import model

class HomeBorrower extends StatefulWidget {
  const HomeBorrower({super.key});

  @override
  State<HomeBorrower> createState() => _HomeBorrowerState();
}

class _HomeBorrowerState extends State<HomeBorrower> {
  int _selectedTabIndex = 0;

  List<RequestItem> _requestedItems = [];

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

  Widget _assetlist() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8B5B46),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ✅ GridView สินค้าหลัก
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      AssetCard(
                        name: 'Notebook',
                        id: '00001',
                        imagePath: 'assets/images/notebook.png',
                        status: 'Available',
                        onAdd: _addItem,
                      ),
                      AssetCard(
                        name: 'Ipad',
                        id: '00002',
                        imagePath: 'assets/images/ipad.png',
                        status: 'Available',
                        onAdd: _addItem,
                      ),
                      AssetCard(
                        name: 'Board game',
                        id: '00003',
                        imagePath: 'assets/images/boardgame.png',
                        status: 'Available',
                        onAdd: _addItem,
                      ),
                      AssetCard(
                        name: 'Power bank',
                        id: '00004',
                        imagePath: 'assets/images/powerbank.png',
                        status: 'Available',
                        onAdd: _addItem,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ แสดงรายการสินค้าที่ถูกกด + (1–3 ช่องหรือมากกว่า)
                  if (_requestedItems.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Requested Items:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _requestedItems.length,
                          itemBuilder: (context, index) {
                            final item = _requestedItems[index];
                            return Card(
                              color: const Color(0xFFF6C68E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                leading: Image.asset(item.image, width: 60),
                                title: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Borrow: ${item.borrowDate.day}/${item.borrowDate.month}/${item.borrowDate.year}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.brown,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _requestedItems.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addItem(String id, String name, String imagePath) async {
    final newItem = RequestItem(
      id: id,
      name: name,
      image: imagePath,
      borrowDate: DateTime.now(),
      returnDate: DateTime.now().add(const Duration(days: 3)),
      status: 'Pending',
    );

    setState(() {
      _requestedItems.add(newItem);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomBar(role: 1, username : name, newItem: newItem),
      ),
    );

    // แสดง Snackbar แจ้งเตือน
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$name added to request list ✅")));
  }
}

// ---------------------------------------------
// ส่วน History เดิม
Widget _history() {
  return Card(
    color: const Color(0xFF8B5B46),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF6C68E), width: 5.0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('ID: 0003', style: TextStyle(color: Colors.white)),
                      Text(
                        'Name: Board game',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/boardgame.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
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
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ---------------------------------------------
// ส่วน UI ย่อยเดิม (searchbar / date)
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF6C68E),
            foregroundColor: const Color(0xFF4A3831),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 0,
          ),
          child: const Row(
            children: [
              Icon(Icons.search, size: 18),
              SizedBox(width: 8),
              Text("Search", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "search here...",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    ),
  );
}

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
        Text(date, style: const TextStyle(color: Colors.black87, fontSize: 18)),
      ],
    ),
  );
}

// ---------------------------------------------
// ✅ AssetCard (กด + แล้วเพิ่มรายการในหน้า)
class AssetCard extends StatelessWidget {
  final String name;
  final String id;
  final String imagePath;
  final String status;
  final Function(String, String, String) onAdd; // callback

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
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(imagePath, height: 90),
              Transform.translate(
                offset: const Offset(0, -30),
                child: GestureDetector(
                  onTap: () {
                    print("✅ Add pressed: $name");
                    onAdd(id, name, imagePath);
                  },
                  child: const Icon(Icons.add, size: 26, color: Colors.black),
                ),
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
                  const TextSpan(
                    text: 'Status: ',
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                  TextSpan(
                    text: status,
                    style: const TextStyle(
                      color: Color.fromARGB(221, 17, 172, 51),
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

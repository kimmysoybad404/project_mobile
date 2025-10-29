import 'package:flutter/material.dart';

class Homelender extends StatefulWidget {
  const Homelender({super.key});

  @override
  State<Homelender> createState() => _HomelenderState();
}

class _HomelenderState extends State<Homelender> {
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
            color: isActive ? Color(0xFFFEC785) : Colors.white,
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
        color: Color(0xFF8B5B46),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 10),
          Expanded(
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
          ),
        ],
      ),
    );
    // ),
  }
}
//  ------------------------------------------------------------------------------------------------------------------------

Widget _history() {
  final List<Map<String, dynamic>> historyItems = [
    {
      'borrower': 'Tigar',
      'id': '0001',
      'name': 'Notebook',
      'image': 'assets/images/notebook.png',
      'borrowDate': '25/10/2568',
      'returnDate': '25/10/2568',
      'approve': 'Lender01',
      'receive': 'Staff01',
      'width': 100.0,
      'height': 120.0,
    },
    {
      'borrower': 'May',
      'id': '0002',
      'name': 'iPad',
      'image': 'assets/images/ipad.png',
      'borrowDate': '21/8/2568',
      'returnDate': '21/8/2568',
      'approve': 'Lender01',
      'receive': 'Staff01',
      'width': 80.0,
      'height': 80.0,
    },
    {
      'borrower': 'Tigar',
      'id': '0003',
      'name': 'Board game',
      'image': 'assets/images/boardgame.png',
      'borrowDate': '25/2/2568',
      'returnDate': '25/2/2568',
      'approve': 'Lender01',
      'receive': 'Staff01',
      'width': 90.0,
      'height': 100.0,
    },
    {
      'borrower': 'Jane',
      'id': '0004',
      'name': 'Power bank',
      'image': 'assets/images/powerbank.png',
      'borrowDate': '22/1/2568',
      'returnDate': '22/1/2568',
      'approve': 'Lender01',
      'receive': 'Staff01',
      'width': 60.0,
      'height': 90.0,
    },
  ];

  return Container(
    color: const Color(0xFF8B5B46),
    child: Column(
      children: [
        const SizedBox(height: 10),
        _buildSearchBar(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF6C68E), width: 4),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF8B5B46),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔸 Borrower
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEC785),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Borrower: ${item['borrower']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D3A1A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🔸 ID & Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${item['id']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Name: ${item['name']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 🔸 รูปภาพ + วันที่
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: item['width'] as double,
                          height: item['height'] as double,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(item['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Borrow',
                                  style: TextStyle(
                                    color: Color(0xFFFEC785),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _buildDateTag(item['borrowDate']!),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Return',
                                  style: TextStyle(
                                    color: Color(0xFFFEC785),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _buildDateTag(item['returnDate']!),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 🔸 Approve / Receive
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFFEDE6E1),
                    //     borderRadius: BorderRadius.circular(25),
                    //   ),
                    //   child: Text(
                    //     'Approve by: ${item['approve']}',
                    //     textAlign: TextAlign.center,
                    //     style: const TextStyle(
                    //       fontSize: 18,
                    //       color: Color(0xFF8B5B46),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE6E1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Received asset by: ${item['receive']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF8B5B46),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// ------------------------------------------------------------------------------------------------------------------------

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
            backgroundColor: const Color(0xFFFEC785),
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
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image ---
          Image.asset(imagePath, height: 90),
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

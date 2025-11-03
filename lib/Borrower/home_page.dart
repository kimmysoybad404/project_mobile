import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mobile/BottomBar.dart';
import 'request_page.dart';
import 'request_item.dart';

class HomeBorrower extends StatefulWidget {
  const HomeBorrower({super.key});

  @override
  State<HomeBorrower> createState() => _HomeBorrowerState();
}

class _HomeBorrowerState extends State<HomeBorrower> {
  int _selectedTabIndex = 0;

  // ✅ เก็บรายการสินค้าที่ผู้ใช้กด +
  List<RequestItem> _requestedItems = [];

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
                    ? (_isLoading ? _loadingUI() : _assetListFromAPI())
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
          _buildSearchBar(),
          const SizedBox(height: 10),

          if (filteredAssets.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No availible items right now",
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

    setState(() {
      _requestedItems.add(newItem);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomBar(role: 1, username : name, newItem: newItem),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$name added to request list ✅")));
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "search here...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _history() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5B46),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildHistoryCard(
              id: '00002',
              name: 'Ipad',
              image: 'assets/images/ipad.png',
              borrowDate: '10/10/2568',
              returnDate: '10/10/2568',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            _buildHistoryCard(
              id: '00003',
              name: 'Board game',
              image: 'assets/images/boardgame.png',
              borrowDate: '10/8/2568',
              returnDate: '10/8/2568',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String id,
    required String name,
    required String image,
    required String borrowDate,
    required String returnDate,
    required double width,
    required double height,
  }) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ID: $id', style: const TextStyle(color: Colors.white)),
              Text('Name: $name', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateTag('Borrow', borrowDate),
                  const SizedBox(height: 10),
                  _buildDateTag('Return', returnDate),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoBar('Approve by: Lender001'),
          const SizedBox(height: 10),
          _buildInfoBar('Received asset by: Staff001'),
        ],
      ),
    );
  }

  Widget _buildInfoBar(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFDCCFCC),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4A3831),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

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

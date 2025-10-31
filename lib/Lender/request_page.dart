import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int _selectedTabIndex = 0;
  Color DarkBrown = const Color(0xFF8B5B46);
  Color LightBrown = const Color(0xFFFEC785);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
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
                    _buildSearchBar(), // <--- WIDGET ที่แก้ไข
                    const SizedBox(height: 16),
                    IndexedStack(
                      index: _selectedTabIndex,
                      children: [_buildStatusCard()],
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
      child: Row(children: [_buildTabItem("Request", 0)]),
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
            color: LightBrown,
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

  Widget _buildStatusCard() {
    return Column(children: [_buildStatusItem()]);
  }

Widget _buildStatusItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: LightBrown, width: 5),
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
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/images/notebook.png"),
                ), // Make sure this path is in your pubspec.yaml
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Wrapped the Text widget in an Expanded to fix the overflow
              const Expanded(
                child: Text(
                  "Waiting for approve",
                  style: TextStyle(
                    color: Color(0xFFF9E076),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // --- FIX: Create both a controller and a focus node ---
                      final TextEditingController reasonController =
                          TextEditingController();

                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text(
                              "Reason for Rejection",
                              style: TextStyle(color: LightBrown),
                            ),
                            backgroundColor: DarkBrown,
                            content: TextField(
                              style: TextStyle(color: LightBrown),
                              controller: reasonController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Enter reason here...",
                                hintStyle: TextStyle(color: LightBrown),
                              ),
                              maxLines: 3,
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: LightBrown),
                                ),
                                onPressed: () {
                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // Close the dialog
                                },
                              ),
                              // Reject Button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF48A8A),
                                ),
                                child: Text(
                                  "Reject",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {

                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF48A8A), // Red
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ), // Adjusted padding
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text("Reject", style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Handle approve logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90C695), // Green
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ), // Adjusted padding
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Approve",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
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
}

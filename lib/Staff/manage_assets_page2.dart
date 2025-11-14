import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ManageAssetsPage2 extends StatefulWidget {
  const ManageAssetsPage2({super.key});

  @override
  State<ManageAssetsPage2> createState() => _ManageAssetsPage2State();
}

class _ManageAssetsPage2State extends State<ManageAssetsPage2>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final Color DarkBrown = const Color(0xFF8B5B46);
  final Color LightBrown = const Color(0xFFFEC785);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> assets = [];

  List<Map<String, dynamic>> recoveryAssets = [
    {
      "id": "R001",
      "name": "iPad Gen 9",
      "image": "assets/images/Phone.png",
      "status": "Borrowed",
      "borrowBy": "Aut Naja",
      "borrowDate": "25/10/2568",
      "returnDate": "27/10/2568",
    },
    {
      "id": "R002",
      "name": "Projector",
      "image": "assets/images/notebook.png",
      "status": "Pending Return",
      "borrowBy": "Kaiwa ISUS",
      "borrowDate": "28/10/2568",
      "returnDate": "31/10/2568",
    },
  ];

  final List<Map<String, dynamic>> imageOptions = [
    {
      'value': 'assets/images/notebook.png',
      'icon': Icons.laptop_mac,
      'label': 'Notebook',
    },
    {
      'value': 'assets/images/apple_pencil_2.png',
      'icon': Icons.edit,
      'label': 'Apple Pencil',
    },
    {
      'value': 'assets/images/powerbank.png',
      'icon': Icons.battery_charging_full,
      'label': 'Powerbank',
    },
    {
      'value': 'assets/images/Camera.png',
      'icon': Icons.camera_alt,
      'label': 'Camera',
    },
    {
      'value': 'assets/images/boardgame.png',
      'icon': Icons.dashboard,
      'label': 'Board Game',
    },
    {'value': 'assets/images/Mouse.png', 'icon': Icons.mouse, 'label': 'Mouse'},
    {
      'value': 'assets/images/Phone.png',
      'icon': Icons.phone_iphone,
      'label': 'Phone',
    },
    {
      'value': 'assets/images/ipad.png',
      'icon': Icons.tablet_mac,
      'label': 'Ipad',
    },
  ];

  // --- Fetch data from the server ---
  Future<void> fetchAssets() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/storage"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          assets = data.map((item) {
            return {
              "id": item['ID'].toString(),
              "name": item['Name'] ?? 'Unknown',
              "image": item['imageName'] != null && item['imageName'].isNotEmpty
                  ? "assets/images/${item['imageName']}"
                  : "assets/images/default.png",
              "status": item['Status'] ?? 'Unknown',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load assets');
      }
    } catch (e) {
      print('Error fetching assets: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    fetchAssets();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
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
                          _buildSearchBar(),
                          const SizedBox(height: 2),
                          IndexedStack(
                            index: _selectedTabIndex,
                            children: [
                              _buildStatusCard(),
                              _buildRecoveryCard(),
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
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
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
      child: Row(
        children: [
          _buildTabItem("Assets Managing", 0),
          _buildTabItem("Assets Receive", 1),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "search here...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          if (_selectedTabIndex == 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () {
                  showAddDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEC785),
                  foregroundColor: const Color(0xFF4A3831),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  elevation: 2,
                ),
                child: const Icon(Icons.add, size: 24),
              ),
            ),
        ],
      ),
    );
  }

  // Status card : if avaliable
  Widget _buildStatusCard() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final item = assets[index];
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: ID, Name, Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CheckStatus(item["status"]),
                    const SizedBox(height: 8),
                    Text(
                      "ID: ${item["id"]}",
                      style: const TextStyle(
                        color: Color(0xFF4A3831),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item["name"]}",
                      style: const TextStyle(
                        color: Color(0xFF4A3831),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side: Image and buttons
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E5C9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(item["image"], width: 90, height: 90),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildSmallButton(
                        "Edit",
                        item["status"] == "Available"
                            ? Colors.grey
                            : Colors.grey.shade400,
                        item["status"] == "Available"
                            ? () => showEditDialog(item)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      _buildSmallButton(
                        "Delete",
                        item["status"] == "Available"
                            ? Colors.redAccent
                            : Colors.grey.shade400,
                        item["status"] == "Available"
                            ? () => showDeleteDialog(item)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Recovery cards
  Widget _buildRecoveryCard() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recoveryAssets.length,
      itemBuilder: (context, index) {
        final item = recoveryAssets[index];
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
                    "ID: ${item["id"]}",
                    style: const TextStyle(
                      color: Color(0xFF4A3831),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  _CheckStatus(item["status"]),
                  Text(
                    "${item["name"]}",
                    style: const TextStyle(
                      color: Color(0xFF4A3831),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
                    child: Image.asset(item["image"], width: 90, height: 90),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDateText("BorrowBy"),
                                const SizedBox(height: 25),
                                _buildDateText("Borrow"),
                                const SizedBox(height: 25),
                                _buildDateText("Return"),
                                const SizedBox(height: 25),
                                _buildDateText("ActualReturn"),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateBox(item["borrowBy"] ?? "-"),
                            const SizedBox(height: 10),
                            _buildDateBox(item["borrowDate"] ?? "-"),
                            const SizedBox(height: 10),
                            _buildDateBox(item["returnDate"] ?? "-"),
                            const SizedBox(height: 10),
                            _buildDateBox(item["returnDate"] ?? "-"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5B46),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Confirm that ${item["name"]} has been returned by ${item["borrowBy"]}?",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              assets.add({
                                                "id": item["id"],
                                                "name": item["name"],
                                                "image": item["image"],
                                                "status": "Available",
                                                "borrowDate":
                                                    item["borrowDate"],
                                                "returnDate":
                                                    item["returnDate"],
                                              });
                                              recoveryAssets.remove(item);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            "Confirm Return",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            elevation: 3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            elevation: 3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      "Confirm Return",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Check if status == Available ? Not Available
  Widget _CheckStatus(String status) {
    Color bgColor = const Color(0xFFF9E5C9);
    Color textColor = const Color(0xFF4A3831);
    IconData iconData = Icons.help_outline;

    switch (status) {
      case "Available":
        bgColor = const Color(0xFFD9F8C4); // เขียวอ่อนอบอุ่น
        textColor = const Color(0xFF3B7A2A);
        iconData = Icons.check_circle;
        break;

      case "Borrowed":
        bgColor = const Color(0xFFD4E4FF); // ฟ้าอ่อน
        textColor = const Color(0xFF3A5E9A);
        iconData = Icons.book_outlined;
        break;

      case "Pending":
        bgColor = const Color(0xFFFFE6B8); // เหลืองอ่อน
        textColor = const Color(0xFF8B5B46);
        iconData = Icons.hourglass_bottom;
        break;

      case "Disabled":
        bgColor = const Color(0xFFE0E0E0); // เทาอ่อน
        textColor = const Color(0xFF6B6B6B);
        iconData = Icons.cancel;
        break;

      default:
        bgColor = const Color(0xFFF9E5C9);
        textColor = const Color(0xFF4A3831);
        iconData = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: textColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 18, color: textColor),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

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
              Icon(Icons.calendar_today, color: db, size: 10),
              SizedBox(width: 6),
              Text(date, style: const TextStyle(color: db, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(String text, Color color, VoidCallback? onTap) {
    final bool isDisabled = onTap == null;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey.shade400 : color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: isDisabled ? 0 : 3,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDisabled ? Colors.white70 : Colors.white,
        ),
      ),
    );
  }

  // Add Dialog
  void showAddDialog() {
    String localStatus = 'Available';
    String localName = '';
    String localImage = 'assets/images/notebook.png';
    bool showError = false;

    final List<Map<String, dynamic>> statusOptions = [
      {
        'value': 'Available',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'label': 'Available',
      },
      {
        'value': 'Borrowed',
        'icon': Icons.book,
        'color': Colors.blue,
        'label': 'Borrowed',
      },
      {
        'value': 'Pending',
        'icon': Icons.hourglass_bottom,
        'color': Colors.orange,
        'label': 'Pending',
      },
      {
        'value': 'Disabled',
        'icon': Icons.cancel,
        'color': Colors.redAccent,
        'label': 'Disabled',
      },
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add New Asset",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEC785),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(localImage, fit: BoxFit.contain),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDropdownSection(
                          title: "Select Image",
                          value: localImage,
                          options: imageOptions,
                          setStateDialog: setStateDialog,
                          onChanged: (v) => localImage = v!,
                        ),
                        _buildDropdownSection(
                          title: "Select Status",
                          value: localStatus,
                          options: statusOptions,
                          setStateDialog: setStateDialog,
                          onChanged: (v) => localStatus = v!,
                        ),
                      ],
                    ),

                    _buildTextFieldSection(
                      title: "Name",
                      hint: "Enter asset name...",
                      controller: TextEditingController(text: localName),
                      onChanged: (v) => localName = v,
                    ),

                    if (showError)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF48A8A).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF48A8A).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFF48A8A),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Please enter asset name before saving.",
                                style: TextStyle(
                                  color: Color(0xFFF48A8A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (localName.trim().isEmpty) {
                                setStateDialog(() => showError = true);
                                return;
                              }

                              // API call to add asset
                              final response = await http.post(
                                Uri.parse("http://10.0.2.2:3000/add-storage"),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  "name": localName,
                                  "status": localStatus,
                                  "imageName": localImage.split('/').last,
                                }),
                              );

                              if (response.statusCode == 200) {
                                final data = jsonDecode(response.body);
                                print("Asset added: $data");

                                // Optionally update local list
                                setState(() {
                                  assets.add({
                                    'id': data['insertId'],
                                    'name': localName,
                                    'status': localStatus,
                                    'image': localImage,
                                  });
                                });

                                Navigator.of(context).pop();
                              } else {
                                print("Error adding asset: ${response.body}");
                              }
                            },

                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              "Add",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 3,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Edit Dialog
  void showEditDialog(Map<String, dynamic> item) {
    String localStatus = item['status'] ?? 'Available';
    String localName = item['name'] ?? '';
    String localImage = item['image'] ?? 'assets/images/notebook.png';
    bool showError = false;

    final List<Map<String, dynamic>> statusOptions = [
      {
        'value': 'Available',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'label': 'Available',
      },
      {
        'value': 'Borrowed',
        'icon': Icons.book,
        'color': Colors.blue,
        'label': 'Borrowed',
      },
      {
        'value': 'Pending',
        'icon': Icons.hourglass_bottom,
        'color': Colors.orange,
        'label': 'Pending',
      },
      {
        'value': 'Disabled',
        'icon': Icons.cancel,
        'color': Colors.redAccent,
        'label': 'Disabled',
      },
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEC785),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(localImage, fit: BoxFit.contain),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDropdownSection(
                          title: "Select Image",
                          value: localImage,
                          options: imageOptions,
                          setStateDialog: setStateDialog,
                          onChanged: (v) => localImage = v!,
                        ),
                        _buildDropdownSection(
                          title: "Select Status",
                          value: localStatus,
                          options: statusOptions,
                          setStateDialog: setStateDialog,
                          onChanged: (v) => localStatus = v!,
                        ),
                      ],
                    ),

                    _buildTextFieldSection(
                      title: "Name",
                      hint: "Enter asset name...",
                      controller: TextEditingController(text: localName),
                      onChanged: (v) => localName = v,
                    ),

                    if (showError)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF48A8A).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF48A8A).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFF48A8A),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Please enter asset name before saving.",
                                style: TextStyle(
                                  color: Color(0xFFF48A8A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (localName.trim().isEmpty) {
                                setStateDialog(() => showError = true);
                                return;
                              }

                              setState(() {
                                // Generate a new ID (you can customize this logic)
                                int newId = assets.isNotEmpty
                                    ? (assets
                                              .map((e) => e['id'] as int)
                                              .reduce((a, b) => a > b ? a : b) +
                                          1)
                                    : 1;

                                assets.add({
                                  'id': newId,
                                  'name': localName,
                                  'status': localStatus,
                                  'image': localImage,
                                  'borrowDate': DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(DateTime.now()),
                                  'returnDate': DateFormat('dd/MM/yyyy').format(
                                    DateTime.now().add(const Duration(days: 1)),
                                  ),
                                });
                              });
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required String value,
    required List<Map<String, dynamic>> options,
    required Function setStateDialog,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEC785),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A3831),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFFFEC785),
              borderRadius: BorderRadius.circular(16),
              items: options.map<DropdownMenuItem<String>>((opt) {
                return DropdownMenuItem(
                  value: opt['value'],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEC785),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        if (opt['icon'] != null)
                          Icon(
                            opt['icon'],
                            color: opt['color'] ?? const Color(0xFF4A3831),
                          ),
                        const SizedBox(width: 6),
                        Text(
                          opt['label'],
                          style: const TextStyle(
                            color: Color(0xFF4A3831),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (v) => setStateDialog(() => onChanged(v)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSection({
    required String title,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEC785),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A3831),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Color(0xFF4A3831)),
            ),
            style: const TextStyle(color: Color(0xFF4A3831)),
            controller: controller,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Delete Dialog
  void showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF8B5B46),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                Text(
                  "Are you sure want to Delete ${item['name']}?",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            assets.remove(item);
                          });
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          "Yes, Delete It",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9534F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 3,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

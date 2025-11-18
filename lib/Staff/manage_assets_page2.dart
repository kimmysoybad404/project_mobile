import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../utils.dart' as util;

class ManageAssetsPage2 extends StatefulWidget {
  const ManageAssetsPage2({super.key});

  @override
  State<ManageAssetsPage2> createState() => _ManageAssetsPage2State();
}

class RecoveryAsset {
  final String id;
  final String assetId; // Add this field
  final String name;
  final String image;
  final String status;
  final String borrowBy;
  final String borrowDate;
  final String returnDate;

  RecoveryAsset({
    required this.id,
    required this.assetId,
    required this.name,
    required this.image,
    required this.status,
    required this.borrowBy,
    required this.borrowDate,
    required this.returnDate,
  });

  factory RecoveryAsset.fromJson(Map<String, dynamic> json) {
    return RecoveryAsset(
      id: json['id'].toString(),
      assetId: json['assetId'].toString(),
      name: json['name'],
      image: json['image'],
      status: json['status'],
      borrowBy: json['borrowBy'],
      borrowDate: json['borrowDate'],
      returnDate: json['returnDate'],
    );
  }
}

class _ManageAssetsPage2State extends State<ManageAssetsPage2>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final Color DarkBrown = const Color(0xFF8B5B46);
  final Color LightBrown = const Color(0xFFFEC785);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> assets = [];

  List<Map<String, dynamic>> recoveryAssets = [];

  final List<Map<String, dynamic>> imageOptions = [
    {
      'value': 'assets/images/notebook.png',
      'icon': Icons.laptop_mac,
      'label': 'Notebook',
    },
    {
      'value': 'assets/images/apple_pencil_1.png',
      'icon': Icons.edit,
      'label': 'Apple Pencil_1',
    },
    {
      'value': 'assets/images/apple_pencil_2.png',
      'icon': Icons.edit,
      'label': 'Apple Pencil_2',
    },
    {
      'value': 'assets/images/apple_pencil_3.png',
      'icon': Icons.edit,
      'label': 'Apple Pencil_3',
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
      'label': 'Board_Game_1',
    },
    {
      'value': 'assets/images/Board_games.png',
      'icon': Icons.dashboard,
      'label': 'Board_Game_2',
    },
    {'value': 'assets/images/Mouse.png', 'icon': Icons.mouse, 'label': 'Mouse'},
    {
      'value': 'assets/images/Phone.png',
      'icon': Icons.phone_iphone,
      'label': 'Phone',
    },
    {
      'value': 'assets/images/Phone_2.png',
      'icon': Icons.phone_iphone,
      'label': 'Phone_2',
    },
    {
      'value': 'assets/images/ipad.png',
      'icon': Icons.tablet_mac,
      'label': 'Ipad',
    },
  ];

  final List<Map<String, dynamic>> statusOptions = [
    {
      'value': 'Available',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'label': 'Available',
    },
    // {
    //   'value': 'Borrowed',
    //   'icon': Icons.book,
    //   'color': Colors.blue,
    //   'label': 'Borrowed',
    // },
    // {
    //   'value': 'Pending',
    //   'icon': Icons.hourglass_bottom,
    //   'color': Colors.orange,
    //   'label': 'Pending',
    // },
    {
      'value': 'Disabled',
      'icon': Icons.cancel,
      'color': Colors.redAccent,
      'label': 'Disabled',
    },
  ];

  // --- Fetch data from the server ---

  Future<void> fetchAssets({String query = ""}) async {
    try {
      final token = await util.getToken(context);
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/storage?q=$query"),
        headers: {"authorization": token, "Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          assets = data
              .map((item) {
                return {
                  "id": item['ID'].toString(),
                  "name": item['Name'] ?? 'Unknown',
                  "image":
                      item['imageName'] != null && item['imageName'].isNotEmpty
                      ? "assets/images/${item['imageName']}"
                      : "assets/images/default.png",
                  "status": item['Status'] ?? 'Unknown',
                };
              })
              .where((asset) => asset['status'] != 'Deleted')
              .toList(); // ✅ Exclude deleted assets
        });
      } else {
        throw Exception('Failed to load assets');
      }
    } catch (e) {
      print('Error fetching assets: $e');
    }
  }

  // -- Async function to update asset on the server ---
  Future<bool> updateAssetToServer({
    required int id,
    required String name,
    required String status,
    required String imageName,
  }) async {
    final url = Uri.parse("http://10.0.2.2:3000/edit-storage");
    final token = await util.getToken(context);
    final response = await http.post(
      url,
      headers: {"authorization": token, "Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "name": name,
        "status": status,
        "imageName": imageName,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed: ${response.body}");
      return false;
    }
  }

  // -- Fetch recovery assets as model ---
  Future<List<RecoveryAsset>> fetchRecoveryAssets() async {
    final token = await util.getToken(context);
    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/recovery-assets"),
      headers: {"authorization": token, "Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RecoveryAsset.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recovery assets: ${response.statusCode}');
    }
  }

  // -- Confirm return API call ---
  Future<bool> confirmReturn(String historyId, int staffId) async {
    try {
      print(
        '🔍 Attempting to confirm return for history ID: $historyId, Staff ID: $staffId',
      );

      final token = await util.getToken(context);
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/confirm-return/$historyId"),
        headers: {"authorization": token, "Content-Type": "application/json"},
        body: jsonEncode({
          "staffId": staffId, // Use the passed staffId parameter
        }),
      );

      print('📡 Response status code: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('✅ Response data: $responseData');

        if (responseData['success'] == true) {
          return true;
        } else {
          print('❌ API returned success: false');
          return false;
        }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Exception during confirm return: $e');
      return false;
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
    fetchRecoveryAssets();
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
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
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
                    children: [
                      _buildTabs(),
                      const SizedBox(height: 10),
                      _buildSearchBar(),
                      const SizedBox(height: 8),

                      /// ⭐ ให้พื้นที่ตรงนี้เป็นของแต่ละ Tab แบบเลื่อนได้อิสระ
                      Expanded(
                        child: IndexedStack(
                          index: _selectedTabIndex,
                          children: [
                            _buildStatusCardScrollable(),
                            _buildRecoveryCardScrollable(),
                          ],
                        ),
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

  Widget _buildStatusCardScrollable() {
    return SingleChildScrollView(child: _buildStatusCard());
  }

  Widget _buildRecoveryCardScrollable() {
    return SingleChildScrollView(child: _buildRecoveryCard());
  }

  //------------MAJOR widgets-------------

  // Status card
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
    return FutureBuilder<List<RecoveryAsset>>(
      future: fetchRecoveryAssets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFEC785)),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "No borrowed assets to recover",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        } else {
          final recoveryAssets = snapshot.data!;

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
                          "ID: ${item.id}",
                          style: const TextStyle(
                            color: Color(0xFF4A3831),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        _CheckStatus(item.status),
                        Text(
                          item.name,
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
                          child: Image.asset(
                            item.image,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/notebook.png',
                                width: 90,
                                height: 90,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDateText("Borrowed Date"),
                                  const SizedBox(height: 25),
                                  _buildDateText("Returned Date"),
                                  const SizedBox(height: 25),
                                  _buildDateText("ActualReturn Date	"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDateBox(formatDate(item.borrowDate)),
                                  const SizedBox(height: 10),
                                  _buildDateBox(formatDate(item.returnDate)),
                                  const SizedBox(height: 10),
                                  _buildDateBox(formatDate(item.returnDate)),
                                  const SizedBox(height: 10),
                                  // _buildDateBox(
                                  //   DateTime.now().toIso8601String(),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Approver / Receiver / Rejecter / Reason
                    if (item.borrowBy != null)
                      _buildInfoLine(
                        icon: Icons.people_outline,
                        text: "Borrower Name : ${item.borrowBy}",
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            confirmReturnDialog(context, item, () async {
                              final success = await confirmReturn(item.id, 6);

                              if (success) {
                                setState(() {});

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Return confirmed successfully!",
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to confirm return"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            "Confirm Return",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
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
      },
    );
  }

  // Helper method for detail items
  Widget _buildDateBox(String date) {
    const darkBrown = Color(0xFF8B5B46);
    const db = Color(0xFF4A3831);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9E5C9),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: db, size: 14),
              SizedBox(width: 6),
              Text(date, style: const TextStyle(color: db, fontSize: 15)),
            ],
          ),
        ),
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
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //------------Important Dialog Widgets-------------

  // Add Dialog
  void showAddDialog() {
    String localStatus = 'Available';
    String localName = '';
    String localImage = 'assets/images/notebook.png';
    bool showError = false;

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
                              final token = await util.getToken(context);
                              final response = await http.post(
                                Uri.parse("http://10.0.2.2:3000/add-storage"),
                                headers: {
                                  "authorization": token,
                                  "Content-Type": "application/json",
                                },
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
    String localStatus = item['status'];
    String localName = item['name'];
    String localImage = item['image'];
    bool showError = false;

    final nameController = TextEditingController(text: localName);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IMAGE
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEC785),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
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
                          onChanged: (v) {
                            setStateDialog(() => localImage = v!);
                          },
                        ),
                        _buildDropdownSection(
                          title: "Select Status",
                          value: localStatus,
                          options: statusOptions,
                          setStateDialog: setStateDialog,
                          onChanged: (v) {
                            setStateDialog(() => localStatus = v!);
                          },
                        ),
                      ],
                    ),

                    _buildTextFieldSection(
                      title: "Name",
                      hint: "Enter asset name...",
                      controller: nameController,
                      onChanged: (v) => localName = v,
                    ),

                    if (showError)
                      const Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 10),
                        child: Text(
                          "Please enter asset name!",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (localName.trim().isEmpty) {
                                setStateDialog(() => showError = true);
                                return;
                              }

                              final success = await updateAssetToServer(
                                id: int.parse(item['id'].toString()),
                                name: localName,
                                status: localStatus,
                                imageName: localImage.replaceFirst(
                                  "assets/images/",
                                  "",
                                ),
                              );

                              if (success) {
                                setState(() {
                                  item['name'] = localName;
                                  item['status'] = localStatus;
                                  item['image'] = localImage;
                                });

                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
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
                  "Are you sure want to delete ${item['name']}?",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pop();

                          final id = item['id'];

                          try {
                            final token = await util.getToken(context);
                            final response = await http.post(
                              Uri.parse("http://10.0.2.2:3000/delete-storage"),
                              headers: {
                                "authorization": token,
                                "Content-Type": "application/json",
                              },
                              body: jsonEncode({"id": id}),
                            );

                            if (response.statusCode == 200) {
                              // update UI
                              setState(() {
                                assets.removeWhere((a) => a['id'] == id);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Asset deleted successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Delete failed: ${response.body}",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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

  // Confirm Return Dialog
  void confirmReturnDialog(
    BuildContext context,
    RecoveryAsset item,
    Function onConfirm,
  ) {
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
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 10),

                Text(
                  "Confirm that ${item.name} has been returned by ${item.borrowBy}?",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final success = await confirmReturn(
                            item.id,
                            6,
                          ); // ✅ Fixed: added staffId 6

                          if (success) {
                            // Refresh the recovery assets list
                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Return confirmed successfully!"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to confirm return"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
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

  //------------Minor widgets-------------

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
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF8B5B46),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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

          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                fetchAssets(query: value); // 🔥 search directly
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search by ID or Name...",
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

  String formatDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(dateString));
    } catch (e) {
      return "-";
    }
  }
}

import 'package:flutter/material.dart';

class ManageAssetsPage2 extends StatefulWidget {
  const ManageAssetsPage2({Key? key}) : super(key: key);

  @override
  State<ManageAssetsPage2> createState() => _ManageAssetsPage2State();
}

class _ManageAssetsPage2State extends State<ManageAssetsPage2> {
  bool isManaging = true;

  List<Map<String, dynamic>> assets = [
    {
      'id': '0001',
      'name': 'Notebook',
      'status': 'Available',
      'borrow': '25/1/2568',
      'return': '25/1/2568',
      'image': 'assets/images/Notebook.png',
      'borrowBy': '-',
    },
    {
      'id': '0002',
      'name': 'Ipad',
      'status': 'Borrowed',
      'borrow': '25/1/2568',
      'return': '25/1/2568',
      'image': 'assets/images/Phone.png',
      'borrowBy': 'John Doe',
    },
    
  ];

  String searchText = '';
  List<String> imageOptions = [
    'assets/images/Notebook.png',
    'assets/images/Phone.png',
    'assets/images/Board_games.png',
    'assets/images/Phone_2.png',
  ];

  // --- show recovery confirm dialog ---
  void showRecoveryConfirmDialog(Map<String, dynamic> item) {
    String localStatus = item['status'] ?? 'Borrowed';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: StatefulBuilder(builder: (context, setStateDialog) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF6b3d2e),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 10),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf3e0c8),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item['image'],
                          width: 44,
                          height: 44,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFc68b59),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selected = await showStatusPickerDialog(context, localStatus);
                            if (selected != null) {
                              setStateDialog(() => localStatus = selected);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf3e0c8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Select Status', style: TextStyle(fontWeight: FontWeight.w600)),
                                Row(
                                  children: [
                                    Text(localStatus, style: TextStyle(fontSize: 12, color: localStatus == 'Available' ? Colors.green :
                                                                                   localStatus == 'Borrowed' ? Colors.orange :
                                                                                   localStatus == 'Disabled' ? Colors.red : Colors.blue)),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_drop_down, size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf3e0c8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('ID: ${item['id']}', textAlign: TextAlign.center),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf3e0c8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('Name: ${item['name']}', textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    item['status'] = localStatus;
                                  });
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                      content: Text('Status of ${item['name']} set to $localStatus'),
                                      backgroundColor: Colors.green.shade700,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFf3e0c8),
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Text('sure?'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade400,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Future<String?> showStatusPickerDialog(BuildContext ctx, String current) {
    return showDialog<String>(
      context: ctx,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 200),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFd7a37a),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf3e0c8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('Available');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Available', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('Borrowed');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Borrowed', textAlign: TextAlign.center, style: TextStyle(color: Colors.orange)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('Disabled');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Disabled', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('Pending');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Pending', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> showImagePickerDialog(BuildContext ctx, String current) {
    return showDialog<String>(
      context: ctx,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 200),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFd7a37a),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf3e0c8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('assets/images/Notebook.png');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Notebook', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('assets/images/Phone.png');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Ipad', textAlign: TextAlign.center),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('assets/images/Board_games.png');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Board game', textAlign: TextAlign.center),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('assets/images/Phone_2.png');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Power bank', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAddDialog() {
    String newStatus = 'Available';
    String newName = '';
    String newImage = 'assets/images/Notebook.png';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF6b3d2e),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFf3e0c8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            newImage,
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFc68b59),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final selected = await showStatusPickerDialog(context, newStatus);
                              if (selected != null) {
                                setStateDialog(() => newStatus = selected);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf3e0c8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Select Status', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Row(
                                    children: [
                                      Text(newStatus, style: TextStyle(fontSize: 12, color: newStatus == 'Available' ? Colors.green :
                                                                                 newStatus == 'Borrowed' ? Colors.orange :
                                                                                 newStatus == 'Disabled' ? Colors.red : Colors.blue)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, size: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final selected = await showImagePickerDialog(context, newImage);
                              if (selected != null) {
                                setStateDialog(() => newImage = selected);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf3e0c8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Select Image', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Row(
                                    children: [
                                      Text(newImage.split('/').last.split('.').first == 'Notebook' ? 'Notebook' :
                                           newImage.split('/').last.split('.').first == 'Phone' ? 'Ipad' :
                                           newImage.split('/').last.split('.').first == 'Board_games' ? 'Board game' :
                                           'Power bank', style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, size: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf3e0c8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) => newName = value,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      assets.add({
                                        'id': (assets.length + 1).toString().padLeft(4, '0'),
                                        'name': newName,
                                        'status': newStatus,
                                        'borrow': '-',
                                        'return': '-',
                                        'image': newImage,
                                        'borrowBy': '-',
                                      });
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFf3e0c8),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text('Add'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showEditDialog(Map<String, dynamic> item) {
    String localStatus = item['status'] ?? 'Available';
    String localName = item['name'] ?? '';
    String localImage = item['image'] ?? 'assets/images/Notebook.png';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF6b3d2e),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFf3e0c8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            localImage,
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFc68b59),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final selected = await showStatusPickerDialog(context, localStatus);
                              if (selected != null) {
                                setStateDialog(() => localStatus = selected);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf3e0c8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Select Status', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Row(
                                    children: [
                                      Text(localStatus, style: TextStyle(fontSize: 12, color: localStatus == 'Available' ? Colors.green :
                                                                                   localStatus == 'Borrowed' ? Colors.orange :
                                                                                   localStatus == 'Disabled' ? Colors.red : Colors.blue)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, size: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final selected = await showImagePickerDialog(context, localImage);
                              if (selected != null) {
                                setStateDialog(() => localImage = selected);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf3e0c8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Select Image', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Row(
                                    children: [
                                      Text(localImage.split('/').last.split('.').first == 'Notebook' ? 'Notebook' :
                                           localImage.split('/').last.split('.').first == 'Phone' ? 'Ipad' :
                                           localImage.split('/').last.split('.').first == 'Board_games' ? 'Board game' :
                                           'Power bank', style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_drop_down, size: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf3e0c8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                border: InputBorder.none,
                              ),
                              controller: TextEditingController(text: localName),
                              onChanged: (value) => localName = value,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      item['status'] = localStatus;
                                      item['name'] = localName;
                                      item['image'] = localImage;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFf3e0c8),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text('Save'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF6b3d2e),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 10),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFf3e0c8),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.delete, size: 44, color: Colors.black),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFc68b59),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf3e0c8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Name: ${item['name']}', textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  assets.remove(item);
                                });
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFf3e0c8),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Delete'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildManagingUI() {
    final filtered = assets.where((a) {
      final id = (a['id'] ?? '').toString().toLowerCase();
      final name = (a['name'] ?? '').toString().toLowerCase();
      final status = (a['status'] ?? '').toString().toLowerCase();
      final borrow = (a['borrow'] ?? '').toString().toLowerCase();
      final returnDate = (a['return'] ?? '').toString().toLowerCase();
      final query = searchText.toLowerCase();
      return id.contains(query) ||
             name.contains(query) ||
             status.contains(query) ||
             borrow.contains(query) ||
             returnDate.contains(query);
    }).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => searchText = v),
                decoration: InputDecoration(
                  hintText: 'Search bar',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => showAddDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFc68b59),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, idx) {
              final item = filtered[idx];
              Color statusColor = item['status'] == 'Available' ? Colors.green :
                                 item['status'] == 'Borrowed' ? Colors.orange :
                                 item['status'] == 'Disabled' ? Colors.red :
                                 Colors.blue;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: const Color(0xFFc68b59),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item['image'],
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${item['id']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text(item['name'], style: const TextStyle(fontSize: 16, color: Colors.white)),
                            Text('Status: ${item['status']}', style: TextStyle(color: statusColor)),
                            Text('Borrow: ${item['borrow']}', style: const TextStyle(color: Colors.white70)),
                            Text('Return: ${item['return']}', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => showEditDialog(item),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade200, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: const Text('Edit'),
                          ),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () => showDeleteDialog(item),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildRecoveryUI() {
    final filtered = assets.where((a) {
      final id = (a['id'] ?? '').toString().toLowerCase();
      final name = (a['name'] ?? '').toString().toLowerCase();
      final borrowBy = (a['borrowBy'] ?? '').toString().toLowerCase();
      final borrow = (a['borrow'] ?? '').toString().toLowerCase();
      final returnDate = (a['return'] ?? '').toString().toLowerCase();
      final query = searchText.isEmpty ? '' : searchText.toLowerCase(); // Handle empty search
      return (query.isEmpty || id.contains(query) || name.contains(query) || borrowBy.contains(query) || borrow.contains(query) || returnDate.contains(query)) &&
             a['status'] == 'Borrowed';
    }).toList();

    if (filtered.isEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => searchText = v),
                  decoration: InputDecoration(
                    hintText: 'Search by ID, Name, Borrower, Borrow Date, Return Date',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(child: Text('No borrowed assets.', style: TextStyle(color: Colors.black54))),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => searchText = v),
                decoration: InputDecoration(
                  hintText: 'Search by ID, Name, Borrower, Borrow Date, Return Date',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: filtered.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFd7a37a), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item['image'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Borrow by: ${item['borrowBy']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('ID: ${item['id']}'),
                    const SizedBox(height: 6),
                    Text('Name: ${item['name']}'),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.calendar_month_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text('Borrow: ${item['borrow']}'),
                    ]),
                    Row(children: [
                      const Icon(Icons.calendar_month_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text('Return: ${item['return']}'),
                    ]),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => showRecoveryConfirmDialog(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFc68b59),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Confirm return'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7ede2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7ede2),
        elevation: 0,
        title: const Text('Staff', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(backgroundImage: AssetImage('assets/images/Tigar.png')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: const Color(0xFFc68b59), borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => isManaging = true),
                      child: Text('Assets managing', style: TextStyle(color: isManaging ? Colors.white : Colors.white70)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => isManaging = false),
                      child: Text('Assets recovery', style: TextStyle(color: !isManaging ? Colors.white : Colors.white70)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: isManaging ? buildManagingUI() : buildRecoveryUI()),
          ],
        ),
      ),
    );
  }
}
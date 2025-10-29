import 'package:flutter/material.dart';

class ManageAssetsPage2 extends StatefulWidget {
  const ManageAssetsPage2({super.key});

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
      'image': 'assets/images/notebook.png',
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
    'assets/images/notebook.png',
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
                color: const Color(0xFF8B5B46),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  )
                ],
                border: Border.all(color: const Color(0xFFF2BE83), width: 2),
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
                      color: const Color(0xFFFEC785),
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
                      color: const Color(0xFF8B5B46),
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
                              color: const Color(0xFFFEC785),
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
                                  color: const Color(0xFFFEC785),
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
                                  color: const Color(0xFFFEC785),
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
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
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
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
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
              color: const Color(0xFF8B5B46),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEC785),
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
              color: const Color(0xFF8B5B46),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEC785),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('assets/images/notebook.png');
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
    String newImage = 'assets/images/notebook.png';

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
                  color: const Color(0xFF8B5B46),
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
                        color: const Color(0xFFFEC785),
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
                        color: const Color(0xFF8B5B46),
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
                                color: const Color(0xFFFEC785),
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
                                color: const Color(0xFFFEC785),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Select Image', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Row(
                                    children: [
                                      Text(newImage.split('/').last.split('.').first == 'notebook' ? 'Notebook' :
                                           newImage.split('/').last.split('.').first == 'Phone' ? 'Ipad' :
                                           newImage.split('/').last.split('.').first == 'Board_games' ? 'Board game' :
                                           'Power bank', style: const TextStyle(fontSize: 14)),
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
                              color: const Color(0xFFFEC785),
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
                                    backgroundColor: const Color(0xFFFEC785),
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
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
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
    String localImage = item['image'] ?? 'assets/images/notebook.png';

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
                  color: const Color(0xFF8B5B46),
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
                        color: const Color(0xFFFEC785),
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
                        color: const Color(0xFF8B5B46),
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
                                color: const Color(0xFFFEC785),
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
                                color: const Color(0xFFFEC785),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Select Image', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Row(
                                    children: [
                                      Text(localImage.split('/').last.split('.').first == 'notebook' ? 'Notebook' :
                                           localImage.split('/').last.split('.').first == 'Phone' ? 'Ipad' :
                                           localImage.split('/').last.split('.').first == 'Board_games' ? 'Board game' :
                                           'Power bank', style: const TextStyle(fontSize: 14)),
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
                              color: const Color(0xFFFEC785),
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
                                    backgroundColor: const Color(0xFFFEC785),
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
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
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
              color: const Color(0xFF8B5B46),
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
                    color: const Color(0xFFFEC785),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.delete, size: 44, color: Colors.black),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5B46),
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
                                color: const Color(0xFFFEC785),
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
                                backgroundColor: const Color(0xFFF2BE83),
                                foregroundColor: Colors.black,
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
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => searchText = v),
                  decoration: InputDecoration(
                    hintText: 'Search by ID, Name, Status, Borrow, Return',
                    filled: true,
                    fillColor: const Color(0xFFFEC785),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => showAddDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5B46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // เพิ่ม padding ด้านข้างและด้านบน/ล่าง
            itemCount: filtered.length,
            itemBuilder: (context, idx) {
              final item = filtered[idx];
              Color statusColor = item['status'] == 'Available' ? Colors.green :
                                 item['status'] == 'Borrowed' ? Colors.orange :
                                 item['status'] == 'Disabled' ? Colors.red :
                                 Colors.blue;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // ปรับ margin การ์ด
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: const Color(0xFF8B5B46),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ID: ${item['id']}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item['image'],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['name'],
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Status: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    Container(
                                      width: 200,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item['status'],
                                          style: TextStyle(color: statusColor, fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Borrow: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    Container(
                                      width: 200,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item['borrow'],
                                          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Return: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    Container(
                                      width: 200,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item['return'],
                                          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => showEditDialog(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade200,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Edit', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => showDeleteDialog(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade300,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 16)),
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
      final query = searchText.isEmpty ? '' : searchText.toLowerCase();
      return (query.isEmpty || id.contains(query) || name.contains(query) || borrowBy.contains(query) || borrow.contains(query) || returnDate.contains(query)) &&
             a['status'] == 'Borrowed';
    }).toList();

    if (filtered.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => searchText = v),
                    decoration: InputDecoration(
                      hintText: 'Search by ID, Name, Borrower, Borrow Date, Return Date',
                      filled: true,
                      fillColor: const Color(0xFFFEC785),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No borrowed assets.',
            style: TextStyle(color: Colors.black54, fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => searchText = v),
                  decoration: InputDecoration(
                    hintText: 'Search by ID, Name, Borrower, Borrow Date, Return Date',
                    filled: true,
                    fillColor: const Color(0xFFFEC785),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // เพิ่ม padding ด้านข้างและด้านบน/ล่าง
            itemCount: filtered.length,
            itemBuilder: (context, idx) {
              final item = filtered[idx];
              Color statusColor = item['status'] == 'Available' ? Colors.green :
                                 item['status'] == 'Borrowed' ? Colors.orange :
                                 item['status'] == 'Disabled' ? Colors.red :
                                 Colors.blue;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // ปรับ margin การ์ด
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: const Color(0xFF8B5B46),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Borrow by: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                          Container(
                            width: 200,
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEC785),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                item['borrowBy'],
                                style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ID: ${item['id']}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item['image'],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['name'],
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Status: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    Container(
                                      width: 200,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item['status'],
                                          style: TextStyle(color: statusColor, fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Borrow: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    Container(
                                      width: 200,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.calendar_month_outlined, size: 18, color: Colors.black),
                                          const SizedBox(width: 6),
                                          Text(
                                            item['borrow'],
                                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Return: ', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    Container(
                                      width: 200,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.calendar_month_outlined, size: 18, color: Colors.black),
                                          const SizedBox(width: 6),
                                          Text(
                                            item['return'],
                                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => showRecoveryConfirmDialog(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF2BE83),
                            minimumSize: const Size(250, 50),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Confirm Return', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5B46),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabs(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: IndexedStack(
                index: isManaging ? 0 : 1,
                children: [buildManagingUI(), buildRecoveryUI()],
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
          _buildTabItem("Assets Managing", true),
          _buildTabItem("Assets Recovery", false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isManagingTab) {
    bool isActive = isManaging == isManagingTab;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isManaging = isManagingTab;
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
}
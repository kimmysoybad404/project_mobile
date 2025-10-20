import 'package:flutter/material.dart';

class ManageAssetsPage extends StatefulWidget {
  const ManageAssetsPage({Key? key}) : super(key: key);

  @override
  State<ManageAssetsPage> createState() => _ManageAssetsPageState();
}

class _ManageAssetsPageState extends State<ManageAssetsPage> {
  List<Map<String, dynamic>> assets = [
    {
      'id': '0001',
      'name': 'Notebook',
      'status': 'Available',
      'borrow': '25/1/2568',
      'return': '25/1/2568',
      'image': 'assets/images/Notebook.png',
    },
    {
      'id': '0002',
      'name': 'Ipad',
      'status': 'Disabled',
      'borrow': '25/1/2568',
      'return': '25/1/2568',
      'image': 'assets/images/Phone.png',
    },
  ];

  final TextEditingController searchController = TextEditingController();

  void showAddDialog() {
    String name = '';
    String status = 'Available';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFd7a37a),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Asset', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'Available', child: Text('Available')),
                  DropdownMenuItem(value: 'Disabled', child: Text('Disabled')),
                ],
                onChanged: (value) => status = value!,
                decoration: const InputDecoration(labelText: 'Select Status'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  assets.add({
                    'id': '000${assets.length + 1}',
                    'name': name,
                    'status': status,
                    'borrow': '-',
                    'return': '-',
                    'image': 'assets/images/Notebook.png',
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFd7a37a),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Delete Asset', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Delete ${item['name']} ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() => assets.remove(item));
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/Tigar.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle buttons
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFc68b59),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Assets managing', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Assets recovery', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar and Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
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
                  onPressed: showAddDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFc68b59),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Asset List
            Expanded(
              child: ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final item = assets[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: const Color(0xFFc68b59),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(item['image'], height: 60, width: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${item['id']}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text(item['name'],
                                    style: const TextStyle(fontSize: 16, color: Colors.white)),
                                Text('Status: ${item['status']}',
                                    style: TextStyle(
                                      color: item['status'] == 'Available' ? Colors.greenAccent : Colors.redAccent,
                                    )),
                                Text('Borrow: ${item['borrow']}',
                                    style: const TextStyle(color: Colors.white70)),
                                Text('Return: ${item['return']}',
                                    style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade200,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Edit'),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () => showDeleteDialog(item),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade300,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
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
        ),
      ),
    );
  }
}

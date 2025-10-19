import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomeBorrower extends StatefulWidget {
  const HomeBorrower({super.key});

  @override
  State<HomeBorrower> createState() => _HomeBorrowerState();
}

class _HomeBorrowerState extends State<HomeBorrower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDF8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // --- Tab Buttons ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF8B5B46,
                  ), // ✅ สีน้ำตาลพื้นหลังเหมือนในรูป
                  borderRadius: BorderRadius.circular(40), // ✅ ทำให้โค้งยาว
                ),
                padding: const EdgeInsets.all(10), // ขอบใน
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFCCB90,
                          ), // ✅ สีครีมส้มของ Browse
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Center(
                          child: Text(
                            'Browse asset list',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // ✅ สีขาวของ History
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Center(
                          child: Text(
                            'History',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // --- Asset Cards Grid ---
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5E47),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
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

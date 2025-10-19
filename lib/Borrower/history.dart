import 'package:flutter/material.dart';
// import 'package:project_mobile/Borrower/home_page.dart';
import 'package:project_mobile/Borrower/home_page.dart'; // <-- ต้อง uncomment และใช้ path จริง


class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                child: Row(
                  children: [
                    // ปุ่ม Browse asset list → ไปหน้า home_page.dart
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeBorrower(), // เรียก class HomeBorrower ครั้งเดียว
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'Browse asset list',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    // ปุ่ม History
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // อยู่หน้า History อยู่แล้ว
                          print('History clicked');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(252, 203, 144, 1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'History',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 20,
                              ),
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

            // --- Asset Card ---
            Card(
              color: const Color(0xFF8B5E3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID + Name
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

                    // --- Icon + Borrow / Return ---
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6B871),
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/boardgame.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),

                        // Borrow / Return Column
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFCC80),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black87,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '25/1/2568',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Text(
                                  'Return ',
                                  style: TextStyle(
                                    color: Color(0xFFF6C68E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFCC80),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black87,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '25/1/2568',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // --- Approve + Received ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE6E1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Approve by: Lender001',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF8B5E3C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE6E1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Received asset by: Staff001',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF8B5E3C),
                        ),
                      ),
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

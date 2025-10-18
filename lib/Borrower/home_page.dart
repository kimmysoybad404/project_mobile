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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BorrowerHomePage(),
    );
  }
}

class BorrowerHomePage extends StatelessWidget {
  const BorrowerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color lightOrange = const Color(0xFFFDC886);
    final Color darkBrown = const Color(0xFF724E32);
    final Color background = const Color(0xFFFDF7F0);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: lightOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: const Text(
                            "Tigar",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Borrower",
                          style:
                              TextStyle(color: Colors.grey, fontSize: 14),

                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: lightOrange,
                    // backgroundImage: AssetImage("assets/hamster.png"),
                  )
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: darkBrown.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: darkBrown.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        child: const Text(
                          "Browse asset list",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        child: const Text(
                          "History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Grid items
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: darkBrown,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: const [
                    AssetCard(
                      imagePath: "assets/images/notebook.png",
                      name: "Notebook",
                      id: "00001",
                    ),
                    AssetCard(
                      imagePath: "assets/images/ipad.png",
                      name: "Ipad",
                      id: "00002",
                    ),
                    AssetCard(
                      imagePath: "assets/images/bord.png",
                      name: "Board game",
                      id: "00003",
                    ),
                    AssetCard(
                      imagePath: "assets/images/power.png",
                      name: "Power bank",
                      id: "00004",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: const Offset(0, -2))
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.calendar_today, color: Colors.grey),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.home, color: Colors.orange, size: 28),
                ),
                Icon(Icons.grid_view, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssetCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String id;

  const AssetCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final Color lightOrange = const Color(0xFFFDC886);

    return Container(
      decoration: BoxDecoration(
        color: lightOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.add, color: Colors.brown[800])),
          Expanded(
            child: Center(
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          Text("ID:$id", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: const [
              Text("Status: ",
                  style: TextStyle(fontSize: 12, color: Colors.black)),
              Text("Available",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
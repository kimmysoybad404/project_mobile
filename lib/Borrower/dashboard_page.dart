import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🟧 Header Row (Box + Avatar)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🟠 Name Box (Tigar, Borrower)
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC68A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tigar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Borrower",
                            style: TextStyle(color: Colors.brown),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 🟤 Add small horizontal spacing (closer than before)
                  const SizedBox(width: 8),

                  // 🟤 Avatar outside box but close
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.brown,
                    child: Icon(Icons.pets, color: Colors.white, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🟧 Pie Chart Section
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC68A),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Total Assets Today : 45",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pie Chart
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: 70,
                              title: '70%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.orange,
                              value: 20,
                              title: '20%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            ),
                            PieChartSectionData(
                              color: Colors.red,
                              value: 10,
                              title: '10%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegend(Colors.green, "Available"),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.orange, "Borrowed"),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.red, "Disabled"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🟩 Available Card
              _buildStatusCard(Colors.green, "Available", 17),
              const SizedBox(height: 10),

              // 🟧 Borrowed Card
              _buildStatusCard(Colors.orange, "Borrowed", 8),
              const SizedBox(height: 10),

              // 🟥 Disabled Card
              _buildStatusCard(Colors.red, "Disabled", 3),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Legend Builder
  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 🔸 Status Card Builder
  Widget _buildStatusCard(Color color, String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalAssets = 0;
  int available = 0;
  int borrowed = 0;
  int disabled = 0;
  int pending = 0;

  @override
  void initState() {
    super.initState();
    fetchStorageData();
  }

  Future<void> fetchStorageData() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:3000/storage"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        int a = 0, b = 0, d = 0, p = 0;
        for (var item in data) {
          switch (item['Status']) {
            case 'Available':
              a++;
              break;
            case 'Borrowed':
              b++;
              break;
            case 'Disabled':
              d++;
              break;
            case 'Pending':
              p++;
              break;
          }
        }

        setState(() {
          totalAssets = data.length;
          available = a;
          borrowed = b;
          disabled = d;
          pending = p;
        });
      } else {
        throw Exception('Failed to load storage data');
      }
    } catch (e) {
      print('Error fetching storage data: $e');
    }
  }

  Widget _strokedText(String text, {double fontSize = 16}) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,

          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC68A),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Total Assets Today : $totalAssets",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: available.toDouble(),
                              title: totalAssets > 0
                                  ? '${((available / totalAssets) * 100).toStringAsFixed(0)}%'
                                  : '0%',
                              titlePositionPercentageOffset: 0.6,
                              badgeWidget: _strokedText(
                                totalAssets > 0
                                    ? '${((available / totalAssets) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                fontSize: 15,
                              ),
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: Colors.blue,
                              value: borrowed.toDouble(),
                              title: '',
                              badgeWidget: _strokedText(
                                totalAssets > 0
                                    ? '${((borrowed / totalAssets) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                fontSize: 15,
                              ),
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: Colors.orange,
                              value: pending.toDouble(),
                              title: '',
                              badgeWidget: _strokedText(
                                totalAssets > 0
                                    ? '${((pending / totalAssets) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                fontSize: 15,
                              ),
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: Colors.red,
                              value: disabled.toDouble(),
                              title: '',
                              badgeWidget: _strokedText(
                                totalAssets > 0
                                    ? '${((disabled / totalAssets) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                fontSize: 15,
                              ),
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegend(Colors.green, "Available"),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.blue, "Borrowed"),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.orange, "Pending"),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.red, "Disabled"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildStatusCard(Colors.green, "Available", available),
              const SizedBox(height: 10),
              _buildStatusCard(Colors.blue, "Borrowed", borrowed),
              const SizedBox(height: 10),
              _buildStatusCard(Colors.orange, "Pending", pending),
              const SizedBox(height: 10),
              _buildStatusCard(Colors.red, "Disabled", disabled),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

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
          _strokedText(label, fontSize: 18),
          _strokedText(count.toString(), fontSize: 18),
        ],
      ),
    );
  }
}

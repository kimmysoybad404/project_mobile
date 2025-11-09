import 'package:flutter/material.dart';

class RequestPageLender extends StatefulWidget {
  const RequestPageLender({super.key});

  @override
  State<RequestPageLender> createState() => _RequestPageLenderState();
}

class _RequestPageLenderState extends State<RequestPageLender>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final Color DarkBrown = const Color(0xFF8B5B46);
  final Color LightBrown = const Color(0xFFFEC785);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      body: SafeArea(
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
                        children: [_buildStatusCard()],
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

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
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
      child: Row(children: [_buildTabItem("Request", 0)]),
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "search here...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final List<Map<String, String>> requests = [
      {"id": "00001", "name": "Notebook", "image": "notebook.png"},
      {"id": "00002", "name": "apple_pencil_2", "image": "apple_pencil_2.png"},
      {"id": "00003", "name": "powerbank", "image": "powerbank.png"},
    ];

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final item = requests[index];
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
                    ),
                  ),
                  Text(
                    "Name: ${item["name"]}",
                    style: const TextStyle(
                      color: Color(0xFF4A3831),
                      fontWeight: FontWeight.bold,
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
                      "assets/images/${item["image"]}",
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildDateBox("Borrow", "25/1/2568"),
                        const SizedBox(height: 12),
                        _buildDateBox("Return", "25/1/2568"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStatusFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateBox(String label, String date) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A3831),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9E5C9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF4A3831),
                ),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF4A3831),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFooter() {
    const Color statusColor = Color(0xFF8B5B46);
    const IconData statusIcon = Icons.schedule;
    const String statusText = "Waiting for Approve";

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: statusColor.withOpacity(0.15),
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(color: statusColor.withOpacity(0.4), width: 2),
        //   ),
        //   child: Row(
        //     children: const [
        //       Icon(statusIcon, color: statusColor, size: 18),
        //       SizedBox(width: 6),
        //       Text(
        //         statusText,
        //         style: TextStyle(
        //           color: statusColor,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 10,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Row(
          children: [
            _buildSmallButton("Reject", const Color(0xFFF48A8A)),
            const SizedBox(width: 8),
            _buildSmallButton("Approve", const Color(0xFF90C695)),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

import 'package:flutter/material.dart';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  State<IdentifyPage> createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  int? selectedIndex;
  Color DarkBrown = Color(0xFF8B5B46);
  Color LightBrown = Color(0xFFFEC785);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> roles = [
      {
        "icon": Icons.people,
        "title": "Borrower",
        "color": DarkBrown,
        "description": "Join as a Borrower",
      },
      {
        "icon": Icons.school,
        "title": "Staff",
        "color": DarkBrown,
        "description": "Join as Staff member",
      },
      {
        "icon": Icons.library_books,
        "title": "Lender",
        "color": DarkBrown,
        "description": "Join as a Lender",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 60, bottom: 40),
            child: Column(
              children: [
                Text(
                  "Select Your Role",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2C23),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Who you are ?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 146, 118, 103),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(roles.length, (index) {
                    final role = roles[index];
                    final isSelected = selectedIndex == index;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isSelected
                                  ? [
                                      role["color"],
                                      role["color"].withOpacity(0.7),
                                    ]
                                  : [Color(0xFFE8D5C4), Color(0xFFE8D5C4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: role["color"].withOpacity(
                                  isSelected ? 0.4 : 0.1,
                                ),
                                blurRadius: isSelected ? 20 : 10,
                                offset: Offset(0, isSelected ? 10 : 5),
                              ),
                            ],
                            border: Border.all(
                              color: isSelected
                                  ? role["color"]
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: role["color"].withOpacity(
                                      isSelected ? 0.2 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    role["icon"],
                                    size: 32,
                                    color: isSelected
                                        ? Colors.white
                                        : role["color"],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        role["title"],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Color(0xFF3E2C23),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        role["description"],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.white70
                                              : Color.fromARGB(
                                                  255,
                                                  146,
                                                  118,
                                                  103,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          if (selectedIndex != null)
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle role selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "You selected ${roles[selectedIndex!]["title"]}",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: roles[selectedIndex!]["color"],
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    disabledBackgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Select a role to continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

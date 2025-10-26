import 'package:flutter/material.dart';
import 'package:project_mobile/LoginPage.dart';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  State<IdentifyPage> createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  int? selectedIndex;
  final Color DarkBrown = Color(0xFF8B5B46);
  final Color LightBrown = Color(0xFFFEC785);

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
        "icon": Icons.library_books,
        "title": "Lender",
        "color": DarkBrown,
        "description": "Join as a Lender",
      },
      {
        "icon": Icons.school,
        "title": "Staff",
        "color": DarkBrown,
        "description": "Join as Staff member",
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
                    color: DarkBrown,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Who you are ?",
                  style: TextStyle(fontSize: 16, color: DarkBrown),
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
                                  ? [role["color"], role["color"]]
                                  : [LightBrown, LightBrown],
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
                                              : DarkBrown,
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
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        int roleValue = selectedIndex! + 1;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(selectRole: roleValue),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedIndex == null
                      ? Colors.grey[300]
                      : roles[selectedIndex!]["color"],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  selectedIndex == null
                      ? "Select a role to continue"
                      : "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedIndex == null
                        ? Colors.grey[600]
                        : Colors.white,
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

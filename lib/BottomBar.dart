import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:project_mobile/Borrower/dashboard_page.dart';
import 'package:project_mobile/Borrower/home_page.dart';
import 'package:project_mobile/Borrower/request_page.dart' as requestborrower;
import 'package:project_mobile/Lender/home_page.dart';
import 'package:project_mobile/Lender/request_page.dart' as requestlender;
import 'package:project_mobile/Login.dart';
import 'package:project_mobile/Staff/home_page.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:project_mobile/identify_page.dart';

//1 = User, 2 = Lender, 3 = Staff

int role = 3;

int role = 1; // 1 = borrower, 2 = Lender, 3 = Staff
class AppBarNaja extends StatelessWidget implements PreferredSizeWidget {
  const AppBarNaja({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  String GetRoleTxt() {
    switch (role) {
      case 1:
        return "User";
      case 2:
        return "Lender";
      case 3:
        return "Staff";
      default:
        return "ม่ายรู้ Who r u จ้ะ ???";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF8CC83),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB67C4D),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/TigarEye.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tigar",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2C23),
                        ),
                      ),
                      Text(
                        GetRoleTxt(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.brown.shade700.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5B46),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // รูปภาพ
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        "assets/images/TigarByeBye.png",
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // ข้อความหลัก
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          'Logout',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(
                                              0xFF8B5B46,
                                            ), // น้ำตาลเข้ม
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // ข้อความยืนยัน
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          'Are you sure to logout?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF8B5B46),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    // ปุ่ม
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF8B5B46),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Color(0xFFFEC785),
                                                  width: 2
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Color(0xFFFEC785),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const IdentifyPage(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFFFEC785),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: const Text(
                                              "Logout",
                                              style: TextStyle(
                                                color: Color(0xFF8B5B46),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // 1 = borrower, 2 = Lender, 3 = Staff
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 1,
  );
  Color DarkBrown = Color(0xFF8B5B46);
  Color LightBrown = Color(0xFFFEC785);

  final List<List<IconData>> roleIcons = [
    [],
    [Icons.receipt_long, Icons.home_filled, Icons.dashboard],
    [Icons.receipt_long, Icons.home, Icons.dashboard],
    [Icons.edit, Icons.home, Icons.dashboard],
  ];

  List<Widget> CheckRole() {
    switch (role) {
      case 1:
        return [
          const requestborrower.RequestPage(),
          const HomeBorrower(),
          const DashboardPage(),
        ];
      case 2:
        return [requestlender.RequestPage(), const Scaffold(), const DashboardPage()];
      case 3:
        return [const Scaffold(), const Scaffold(), const DashboardPage()];
      default:
        return [Scaffold()];
    }
  }

  List<BottomBarItem> BottomBar() {
    final icons = roleIcons[role];
    return List.generate(
      icons.length,
      (index) => BottomBarItem(
        inActiveItem: Icon(icons[index], color: Colors.blueGrey),
        activeItem: Icon(icons[index], color: LightBrown),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Pages = CheckRole();
    final BottomBarNAJA = BottomBar();

    return SafeArea(
      child: Scaffold(
        backgroundColor: LightBrown,
        extendBody: true,
        appBar: AppBarNaja(),
        body: PageView(
          controller: _pageController,
          children: Pages,
          onPageChanged: (index) {
            _controller.index = index;
          },
        ),
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          kIconSize: 24,
          kBottomRadius: 20,
          shadowElevation: 5,
          removeMargins: false,
          bottomBarHeight: 50,
          bottomBarItems: BottomBarNAJA,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}

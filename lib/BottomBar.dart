import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:project_mobile/Borrower/dashboard_page.dart';
import 'package:project_mobile/Borrower/home_page.dart' as homepageborrower;
import 'package:project_mobile/Borrower/request_page.dart' as requestborrower;
import 'package:project_mobile/Lender/home_page.dart' as homepageLender;
import 'package:project_mobile/Lender/request_page.dart' as requestlender;
import 'package:project_mobile/Staff/home_page.dart' as homepageStaff;
import 'package:project_mobile/Staff/manage_assets_page2.dart';
import 'package:project_mobile/identify_page.dart';

class AppBarNaja extends StatelessWidget implements PreferredSizeWidget {
  final int role;
  final String name;
  const AppBarNaja({super.key, required this.role, required this.name});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  String GetRoleTxt() {
    switch (role) {
      case 1:
        return "Borrower";
      case 2:
        return "Lender";
      case 3:
        return "Staff";
      default:
        return "Unknown";
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
                        name,
                        style: TextStyle(
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
                  const Spacer(),
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
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        "assets/images/TigarByeBye.png",
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEC785),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF8B5B46,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color(0xFFFEC785),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Color(0xFFFEC785),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const IdentifyPage(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFFEC785,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              "Logout",
                                              style: TextStyle(
                                                color: Color(0xFF8B5B46),
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
                      icon: const Icon(Icons.logout, color: Colors.white),
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
  final int role;
  final String name;
  const BottomBar({super.key, required this.role, required this.name});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 1,
  );

  Color LightBrown = const Color(0xFFFEC785);

  List<Widget> CheckRole() {
    switch (widget.role) {
      case 1:
        return [
          const requestborrower.RequestPage(),
          const homepageborrower.HomeBorrower(),
          const DashboardPage(),
        ];
      case 2:
        return [
          requestlender.RequestPage(),
          const homepageLender.Homelender(),
          const DashboardPage(),
        ];
      case 3:
        return [
          const ManageAssetsPage2(),
          homepageStaff.HomeStaff(),
          const DashboardPage(),
        ];
      default:
        return [const Scaffold()];
    }
  }

  List<BottomBarItem> BottomBarItems() {
    List<IconData> icons;
    switch (widget.role) {
      case 1:
        icons = [Icons.receipt_long, Icons.home_filled, Icons.dashboard];
        break;
      case 2:
        icons = [Icons.receipt_long, Icons.home, Icons.dashboard];
        break;
      case 3:
        icons = [Icons.edit, Icons.home, Icons.dashboard];
        break;
      default:
        icons = [Icons.home];
    }

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
    final pages = CheckRole();
    final bottomItems = BottomBarItems();

    return SafeArea(
      child: Scaffold(
        backgroundColor: LightBrown,
        extendBody: true,
        appBar: AppBarNaja(role: widget.role, name: widget.name),
        body: PageView(
          controller: _pageController,
          children: pages,
          onPageChanged: (index) {
            setState(() {
              _controller.index = index;
            });
          },
        ),
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          kIconSize: 24,
          kBottomRadius: 20,
          shadowElevation: 5,
          bottomBarHeight: 50,
          bottomBarItems: bottomItems,
          onTap: (index) => _pageController.jumpToPage(index),
        ),
      ),
    );
  }
}

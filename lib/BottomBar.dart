import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:project_mobile/Borrower/dashboard_page.dart';
import 'package:project_mobile/Borrower/home_page.dart';
import 'package:project_mobile/Borrower/request_page.dart' as requestborrower;

class AppBarNaja extends StatelessWidget implements PreferredSizeWidget {
  const AppBarNaja({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tigar",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2C23),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "User",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.brown.shade700.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
      
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
  int role = 1;
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
        return [requestborrower.RequestPage(), const HomeBorrower(), const DashboardPage()];
      case 2:
        return [const Scaffold(), const Scaffold(), const DashboardPage()];
      case 3:
        return [const Scaffold(), const Scaffold(), const DashboardPage()];
      default:
        return [const DashboardPage()];
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
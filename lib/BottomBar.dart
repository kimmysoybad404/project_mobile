import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:project_mobile/Borrower/home_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int role = 1;
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 1,
  );

  final List<List<IconData>> roleIcons = [
    [],
    [Icons.receipt_long, Icons.home_filled, Icons.dashboard],
    [Icons.receipt_long, Icons.home, Icons.dashboard],
    [Icons.edit, Icons.home, Icons.dashboard],
  ];

  List<Widget> CheckRole() {
    switch (role) {
      case 1:
        return [const Scaffold(), const HomeBorrower(), const Scaffold()];
      case 2:
        return [const Scaffold(), const Scaffold(), const Scaffold()];
      case 3:
        return [const Scaffold(), const Scaffold(), const Scaffold()];
      default:
        return [const Scaffold()];
    }
  }

  List<BottomBarItem> BottomBar() {
    final icons = roleIcons[role];
    return List.generate(
      icons.length,
      (index) => BottomBarItem(
        inActiveItem: Icon(icons[index], color: Colors.blueGrey),
        activeItem: Icon(icons[index], color: Colors.blueAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Pages = CheckRole();
    final BottomBarNAJA = BottomBar();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(248, 64, 115, 255),
        extendBody: true,
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

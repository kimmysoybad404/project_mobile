import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 1,
  );

  final List<Widget> _pages = [
    const Center(
      child: Text(
        'Request',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
    const Center(
      child: Text('Home', style: TextStyle(fontSize: 24, color: Colors.white)),
    ),
    const Center(
      child: Text(
        'Dashboard',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(248, 64, 115, 255),
        extendBody: true,
        body: PageView(
          controller: _pageController,
          children: _pages,
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

          bottomBarItems: const [
            BottomBarItem(
              inActiveItem: Icon(Icons.receipt_long, color: Colors.blueGrey),
              activeItem: Icon(Icons.receipt_long, color: Colors.blueAccent),
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.home_filled, color: Colors.blueGrey),
              activeItem: Icon(Icons.home_filled, color: Colors.blueAccent),
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.dashboard, color: Colors.blueGrey),
              activeItem: Icon(Icons.dashboard, color: Colors.blueAccent),
            ),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}

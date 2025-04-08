import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  CustomBottomNavBar({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color.fromARGB(255, 149, 223, 255),
            Colors.lightBlueAccent.shade400,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CurvedNavigationBar(
        index: widget.selectedIndex,
        height: 45,
        backgroundColor: Colors.transparent,
        color: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          widget.onTabSelected(index);
        },
        items: [
          Icon(Icons.home,
              color: widget.selectedIndex == 0 ? Colors.black : Colors.grey),
          Icon(Icons.my_library_books_rounded,
              color: widget.selectedIndex == 1 ? Colors.black : Colors.grey),
          Icon(Icons.message_outlined,
              color: widget.selectedIndex == 2 ? Colors.black : Colors.grey),
          Icon(Icons.person_outline,
              color: widget.selectedIndex == 3 ? Colors.black : Colors.grey),
        ],
      ),
    );
  }
}

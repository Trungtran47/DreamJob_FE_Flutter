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
            Colors.white, // Màu nhạt ở trên
            const Color.fromARGB(
                255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
            Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CurvedNavigationBar(
        index: widget.selectedIndex, // Sử dụng selectedIndex từ widget
        height: 45,
        backgroundColor:
            Colors.transparent, // Để phần nền không che mất gradient
        color: Colors.white, // Màu nền của tab
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          widget
              .onTabSelected(index); // Gọi hàm onTabSelected khi tab được chọn
        },
        items: [
          Icon(Icons.insert_drive_file_outlined,
              color: widget.selectedIndex == 0 ? Colors.black : Colors.grey),
          Icon(Icons.message_outlined,
              color: widget.selectedIndex == 1 ? Colors.black : Colors.grey),
          Icon(Icons.home,
              color: widget.selectedIndex == 2 ? Colors.black : Colors.grey),
          Icon(Icons.bookmark_added_outlined,
              color: widget.selectedIndex == 3 ? Colors.black : Colors.grey),
          Icon(Icons.person_outline,
              color: widget.selectedIndex == 4 ? Colors.black : Colors.grey),
        ],
      ),
    );
  }
}

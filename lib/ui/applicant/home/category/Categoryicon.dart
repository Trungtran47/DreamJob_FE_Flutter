import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String imagePath;
  final String label;
  final String routeName; // Thêm tham số cho tên route

  const CategoryIcon({
    required this.imagePath,
    required this.label,
    required this.routeName, // Thêm tham số cho tên route
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Chuyển hướng đến trang mới khi nhấn vào icon
        Navigator.pushNamed(context, routeName);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 50,
            width: 50,
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}

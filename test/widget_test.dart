import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Index for Home Button initially selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Content for selected tab goes here!'),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  CustomBottomNavBar({required this.selectedIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.article_outlined, 0),
              _buildNavItem(Icons.chat_bubble_outline, 1),
              SizedBox(width: 40), // Space for the floating home button
              _buildNavItem(Icons.notifications_none, 3),
              _buildNavItem(Icons.person_outline, 4),
            ],
          ),
        ),
        Positioned(
          bottom: 20, // Adjust position to float above the bar
          left: MediaQuery.of(context).size.width / 2 - 30, // Center the button
          child: FloatingActionButton(
            backgroundColor: selectedIndex == 2 ? Colors.white : Colors.grey,
            onPressed: () => onTabSelected(2),
            child: Icon(
              Icons.home_outlined,
              color: selectedIndex == 2 ? Colors.black : Colors.white,
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () => onTabSelected(index),
    );
  }
}

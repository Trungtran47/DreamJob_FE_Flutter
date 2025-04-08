import 'package:flutter/material.dart';
import 'package:dacn2/ui/applicant/cv/cv.dart'; // Trang CV
import 'package:dacn2/ui/applicant/home/Home.dart'; // Trang Home
import 'package:dacn2/ui/applicant/messager/ApplicantListMessager.dart'; // Trang tin nhắn
import 'package:dacn2/ui/applicant/profile/Profile.dart'; // Trang cá nhân
import 'package:dacn2/ui/applicant/nav/Bottomnav.dart'; // Thanh điều hướng tùy chỉnh
import 'package:dacn2/ui/applicant/savedJob/SavedJobs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Trang "Home" được chọn mặc định

  // Tạo GlobalKey cho mỗi trang để reload lại khi cần thiết
  final GlobalKey<CvPageState> _cvKey = GlobalKey();
  final GlobalKey<ListMessPageState> _listMessKey = GlobalKey();
  final GlobalKey<HomePageState> _homeKey = GlobalKey();
  final GlobalKey<SavedJobsPageState> _notifKey = GlobalKey();
  final GlobalKey<ProfilePageState> _profileKey = GlobalKey();

  // Danh sách các widget tương ứng với các tab
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      CvPage(key: _cvKey), // Trang CV
      ListMessPage(key: _listMessKey), // Trang tin nhắn
      HomePage(key: _homeKey), // Trang Home
      SavedJobsPage(key: _notifKey), // Trang thông báo
      ProfilePage(key: _profileKey), // Trang cá nhân
    ];
  }

  // Hàm xử lý chọn tab
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Sau khi đổi tab, gọi phương thức reload trang mới chọn
    _reloadSelectedPage();
  }
  // Reload lại trang hiện tại
  void _reloadSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        _cvKey.currentState?.reloadPage();
        break;
      case 1:
        _listMessKey.currentState?.reloadPage();
        break;
      case 2:
        _homeKey.currentState?.reloadPage();
        break;
      case 3:
        _notifKey.currentState?.reloadPage();
        break;
      case 4:
        _profileKey.currentState?.reloadPage();
        break;
    }
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected, // Cập nhật chỉ số tab khi nhấn
      ),
    );
  }
}

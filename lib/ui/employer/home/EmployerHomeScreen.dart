import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/employer/blog.dart/blogPage.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/ui/employer/home/EmployerHome.dart';
import 'package:dacn2/ui/employer/mess/EmployerListMessPage.dart';
import 'package:dacn2/ui/employer/profile/ProfileEmployer.dart';
import 'package:dacn2/ui/employer/bottomNavBar/BottomNavBar.dart';
import 'package:dacn2/data/services/company_service.dart';

class EmployerHomeScreen extends StatefulWidget {
  @override
  _EmployerHomeScreenState createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  final CompanyService companyService = CompanyService(baseUrl: Util.baseUrl);
  int _selectedIndex = 0;

  final GlobalKey<ListMessPageState> _listMessKey = GlobalKey();
   final GlobalKey<BlogListPageState> _blogKey = GlobalKey();
  final GlobalKey<EmployerHomeState> _homeKey = GlobalKey();
  final GlobalKey<EmployerProfilePageState> _profileKey = GlobalKey();
 
  late List<Widget> _pages;
  // Tạo GlobalKey cho mỗi trang để reload lại khi cần thiết
  @override
  void initState() {
    super.initState();
    _pages = [
      EmployerHome(key: _homeKey),
      BlogListPage(key: _blogKey),
      ListMessPage(key: _listMessKey),
      EmployerProfilepage(key: _profileKey),
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

  void _reloadSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        _homeKey.currentState?.reloadPage();
        break;
      case 1:
        _blogKey.currentState?.reloadPage();
        break;
      case 2:
        _listMessKey.currentState?.reloadPage();
        break;
      case 3:
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
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

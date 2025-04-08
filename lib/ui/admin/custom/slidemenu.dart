import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideMenu extends StatefulWidget {
  SlideMenu({Key? key}) : super(key: key);

  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  // final UserService _userService = UserService(baseUrl: Util.baseUrl);
  // late User _user;

  // Future<void> getUserr() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userIdFromPrefs = prefs.getInt('userId');
  //   try {
  //     if (userIdFromPrefs != null) {
  //       final user = await _userService.getUserById(userIdFromPrefs);
  //       setState(() {
  //         _user = user;
  //       });
  //     } else {
  //       print('User ID not found in preferences');
  //     }
  //   } catch (e) {
  //     print('Error fetching user: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text("quang@gmail.com."),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'A',
                style: TextStyle(fontSize: 40.0, color: Colors.blueAccent),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang Chủ'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/adminHome');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Blog'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/adminBlog');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Người Dùng'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/adminUser');
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Công Ty'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/adminCompany');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng Xuất'),
            onTap: () async {
              // Hiển thị hộp thoại xác nhận
              bool? confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xác nhận'),
                    content:
                        const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Đăng Xuất'),
                      ),
                    ],
                  );
                },
              );

              if (confirmLogout == true) {
                // Xóa thông tin session
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Điều hướng đến màn hình đăng nhập
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}

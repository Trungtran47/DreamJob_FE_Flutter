// tạo cho tôi trang danh sách người dùng để quản lý
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/admin/custom/slidemenu.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/user.dart'; // Giả sử bạn đã có mô hình User
import 'package:dacn2/data/services/user_service.dart'; // Dịch vụ để lấy danh sách người dùng từ API

class AdminUserPage extends StatefulWidget {
  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  final UserService _userService = UserService(baseUrl: Util.baseUrl);
  late List<User> _users;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Lấy danh sách người dùng khi trang được tạo
  }

  // Phương thức để lấy danh sách người dùng
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Danh sách Người Dùng'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color.fromARGB(255, 149, 223, 255),
                Colors.lightBlueAccent.shade400,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      drawer:  SlideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatar == "0" || user.avatar.isEmpty
                          ? AssetImage(
                              'images/default_profile.png') // Hình ảnh mặc định nếu người dùng không có hình ảnh
                          : NetworkImage(user.avatarUrl), // Hình ảnh người dùng
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(user.email),
                    trailing: _buildStatusChip(user.roles),
                    onTap: () {
                      // Điều hướng tới trang chi tiết người dùng nếu cần
                    },
                  ),
                );
              },
            ),
    );
  }

  // Phương thức xây dựng chip trạng thái người dùng
  Widget _buildStatusChip(int status) {
    Color color;
    String label;

    switch (status) {
      case 1:
        color = Colors.green;
        label = 'Ứng viên';
        break;
      case 3:
        color = Colors.orange;
        label = 'Bạn';
        break;
      case 2:
        color = Colors.blue;
        label = 'Nhà tuyển dụng';
        break;
      default:
        color = Colors.grey;
        label = 'Không xác định';
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}

// Đây là trang Profile của ứng viên
import 'package:dacn2/ui/applicant/profile/UpdateProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/ChatAI/ChatAIPage.dart';
import './profileDetail/SavedJobs.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  void reloadPage() {
    setState(() {
      _loadUser();
    });
  }

  late Future<User> futureUser;
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  late int userId;
  bool isJobSearchEnabled = true;

  @override
  void initState() {
    super.initState();
    futureUser = Future.error('Loading ...'); // Set initial value to error
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        futureUser = userService.getUserById(userId);
      });
    } else {
      setState(() {
        futureUser = Future.error('User ID not found');
      });
    }
  }

  Widget _profileAplicant(User user) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // User Info Section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (user.avatar != "0"
                          ? NetworkImage(user.avatar)
                          : AssetImage('images/default_profile.png'))
                      as ImageProvider,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Email: ${user.email}'),
                    Text('SDT: ${user.phone}'),
                  ],
                ),
              ],
            ),
          ),
          // Experience Section with Edit Icon
          ListTile(
            title: Text(
              'Kinh nghiệm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                user.experience.isNotEmpty ? user.experience : 'Chưa cập nhật',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit_calendar_sharp),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfile(
                      user: user, // Truyền dữ liệu công ty để cập nhật
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    futureUser = userService.getUserById(userId);
                    _loadUser();
                  });
                }
              },
            ),
          ),
          ListTile(
            title: Text(
              'Công việc mong muốn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                user.desiredJob.isNotEmpty ? user.desiredJob : 'Chưa cập nhật',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit_calendar_sharp),
              onPressed: () {
                // Xử lý khi nhấn vào biểu tượng chỉnh sửa
              },
            ),
          ),
          ListTile(
            title: Text(
              'Địa điểm công việc mong muốn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                user.location.isNotEmpty ? user.location : 'Chưa cập nhật',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit_calendar_sharp),
              onPressed: () {
                // Xử lý khi nhấn vào biểu tượng chỉnh sửa
              },
            ),
          ),
          ListTile(
            title: Text(
              'Trạng thái Cv',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                user.cv.isNotEmpty ? "Đã cập nhật " : 'Chưa cập nhật',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit_calendar_sharp),
              onPressed: () {
                // Xử lý khi nhấn vào biểu tượng chỉnh sửa
              },
            ),
          ),

          ListTile(
            leading: Icon(Icons.book),
            title: Text('Hướng dẫn viết CV'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
          Divider(),
          // Account Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Cài đặt tài khoản',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Trò chuyện cùng AI'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.upgrade),
            title: Text('Nâng cấp tài khoản VIP'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.lock),
          //   title: Text('Đổi mật khẩu'),
          //   onTap: () {
          //     // Xử lý khi nhấn vào mục này
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.email),
          //   title: Text('Cài đặt thông báo email'),
          //   onTap: () {
          //     // Xử lý khi nhấn vào mục này
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.phone),
          //   title: Text('Cài đặt số điện thoại'),
          //   onTap: () {
          //     // Xử lý khi nhấn vào mục này
          //   },
          // ),
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
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Xóa hoặc hủy tài khoản'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
          Divider(),
          // Support and Policies Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Chính sách và hỗ trợ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.policy),
            title: Text('Về DreamJob'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Điều khoản dịch vụ'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('Trợ giúp'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Chính sách bảo mật'),
            onTap: () {
              // Xử lý khi nhấn vào mục này
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hồ sơ ứng viên'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // Màu nhạt ở trên
                const Color.fromARGB(
                    255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
                Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return _profileAplicant(snapshot.data!);
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}

// class JobManagementCard extends StatelessWidget {
//   final String title;
//   final int count;
//   final VoidCallback onTap; // Thêm một callback để xử lý nhấn

//   const JobManagementCard({
//     Key? key,
//     required this.title,
//     required this.count,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap, // Gọi hàm khi nhấn vào
//       child: Card(
//         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               SizedBox(height: 8),
//               Text('$count việc làm'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

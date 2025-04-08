import 'package:dacn2/data/services/company_service.dart';
import 'package:dacn2/data/services/post_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../post/PostCard.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../post/CreatePost.dart';
import '../post/EditPostPage.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/ui/employer/mess/EmployerListMessPage.dart';
import 'package:http/http.dart' as http;

class EmployerHome extends StatefulWidget {
  EmployerHome({Key? key}) : super(key: key);
  @override
  EmployerHomeState createState() => EmployerHomeState();
}

class EmployerHomeState extends State<EmployerHome> {
  void reloadPage() {
    setState(() {
      _loadPosts();
      // _loadCompany();
    });
  }

  // void checkCompany() {
  //   setState(() {
  //     _checkCompany();
  //   });
  // }
  bool _notificationsEnabled = false; // Biến lưu trạng thái bật/tắt thông báo
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;
  String? latestMessage = ""; // Biến lưu trữ tin nhắn mới nhất
  late Future<User> futureUser;
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  late Future<List<PostResponse>> futurePosts;
  late Future futureCompany;
  final PostService postService = PostService(baseUrl: Util.baseUrl);
  final CompanyService companyService = CompanyService(baseUrl: Util.baseUrl);
  late List<PostResponse> filteredPosts;
  String searchQuery = '';
  late int userId;
  late Future<Company?> future;

  @override
  void initState() {
    super.initState();
    futurePosts = Future.error('Loading ...'); // Set initial value to error
    _loadPosts();
    // _loadCompany();

    super.initState();
    _initializeNotifications();
    _notificationsEnabled = true; // Bật mặc định
    _saveNotificationSetting(true); // Lưu trạng thái bật vào SharedPreferences
    futureUser = Future.error('Loading ...');
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_notificationsEnabled) {
        _checkForUpdates();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Cấu hình thông báo cục bộ
  void _initializeNotifications() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Tải trạng thái bật/tắt thông báo từ SharedPreferences
  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });
  }

  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications_enabled', value);
  }

  Future<void> _checkForUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getInt('userId'); // Lấy userId hiện tại
    if (currentUserId == null) {
      print("User ID not found.");
      return;
    }
    final response = await http.get(Uri.parse(Util.baseUrl +
        '/user/message_detail/NotiEmployer/$currentUserId/$currentUserId'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        var newMessage = data['content'];
        var newSendingTime = data['sendingTime'];
        var newSenderId = data['userId'];
        String previousMessage = prefs.getString('latest_message') ?? "";
        if (newMessage != previousMessage) {
          setState(() {
            latestMessage = newMessage;
          });
          _showNotification(newMessage, newSendingTime, newSenderId);
          await prefs.setString('latest_message', newMessage);
        }
      }
    } else {
      print('Failed to fetch updates');
    }
  }

  void _showNotification(
      String message, String sendingTime, int newSenderId) async {
    User user = await userService.getUserById(newSenderId);

    Flushbar(
      title: 'Tin nhắn mới',
      message: 'Bạn nhận được tin nhắn từ ${user.fullName}',
      icon: Icon(
        Icons.message,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.blueAccent,
      duration: Duration(seconds: 5), // Hiển thị trong 5 giây
      mainButton: TextButton(
        onPressed: () {
          // Chuyển hướng đến trang tin nhắn
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListMessPage()),
          );
        },
        child: Text(
          'Xem',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey,
      flushbarPosition: FlushbarPosition.TOP, // Hiển thị ở trên cùng
      margin: EdgeInsets.all(10), // Khoảng cách từ cạnh màn hình
      borderRadius: BorderRadius.circular(10), // Bo góc cho thông báo
    ).show(context);
  }

  Future<void> _checkCompany() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        future = companyService.getCompanyByUserId(userId);
      });
      try {
        final company = await future;
        if (company?.companyId == null) {
          print('Chưa có thông tin công ty $company');
          Fluttertoast.showToast(
            msg: "Bạn chưa nhập thông tin công ty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(),
            ),
          ).then((value) {
            if (value == true) {
              _loadPosts(); // Refresh the posts list after creating a new post
            }
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi kiểm tra công ty: $e')),
        );
      }
    } else {
      setState(() {
        future = Future.error('User ID not found');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found')),
      );
    }
  }

  // Future<void> _loadCompany() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userIdFromPrefs = prefs.getInt('userId');
  //   if (userIdFromPrefs != null) {
  //     setState(() {
  //       userId = userIdFromPrefs;
  //       futureCompany = companyService.getCompanyByUserId(userId);
  //     });
  //   } else {
  //     setState(() {
  //       futureCompany = Future.error('User ID not found');
  //     });
  //   }
  // }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        futurePosts = postService.getAllPostsByUserId(userId);
      });
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      futurePosts.then((posts) {
        filteredPosts = posts.where((post) {
          return (post.title.toLowerCase().contains(query.toLowerCase())) ||
              (post.location.toLowerCase().contains(query.toLowerCase())) ||
              (post.salary.toLowerCase().contains(query.toLowerCase())) ||
              (post.experience.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, // Bỏ đường viền bóng
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFB3E5FC), // Xanh nhạt nhẹ ở giữa
                Color(0xFF039BE5), // Xanh đậm hơn ở dưới
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm ...',
              border: InputBorder.none,
              icon: Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        updateSearchQuery('');
                      },
                    )
                  : null,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: _checkCompany,
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _notificationsEnabled =
                    !_notificationsEnabled; // Đổi trạng thái
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _notificationsEnabled
                        ? 'Thông báo đã được bật'
                        : 'Thông báo đã được tắt',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Icon(
              _notificationsEnabled
                  ? Icons.notifications_on_outlined
                  : Icons
                      .notifications_off_outlined, // Icon thay đổi theo trạng thái
              color: Colors.black,
              size: 28,
            ),
          ),
          SizedBox(width: 10), // Thêm khoảng cách giữa icon và cạnh phải
        ],
      ),
      body: FutureBuilder<List<PostResponse>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có bài post nào'));
          } else {
            // Lọc danh sách dựa trên `searchQuery`
            final List<PostResponse> filteredPosts =
                snapshot.data!.where((post) {
              return post.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  post.location
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  post.salary
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  post.experience
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
            }).toList();

            if (filteredPosts.isEmpty) {
              return Center(child: Text('Không tìm thấy bài đăng phù hợp'));
            }

            return ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  postResponse: filteredPosts[index],
                  onDelete: () {
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });
                  },
                  onEdit: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPostPage(postResponse: filteredPosts[index]),
                      ),
                    );
                    if (result == true) {
                      _loadPosts(); // Tải lại danh sách bài đăng sau khi cập nhật thành công
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

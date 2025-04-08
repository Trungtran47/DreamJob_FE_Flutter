import 'package:flutter/material.dart';
import 'package:dacn2/ui/applicant/search/Search.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/applicant/messager/ApplicantListMessager.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:another_flushbar/flushbar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(70); // Chiều cao của AppBar
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _notificationsEnabled = false; // Biến lưu trạng thái bật/tắt thông báo
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;
  String? latestMessage = ""; // Biến lưu trữ tin nhắn mới nhất
  late Future<User> futureUser;
  final UserService userService = UserService(baseUrl: Util.baseUrl);

  @override
  void initState() {
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
        '/user/message_detail/NotiApplicant/$currentUserId/$currentUserId'));
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
      backgroundColor: Colors.blueAccent,
      flushbarPosition: FlushbarPosition.TOP, // Hiển thị ở trên cùng
      margin: EdgeInsets.all(10), // Khoảng cách từ cạnh màn hình
      borderRadius: BorderRadius.circular(10), // Bo góc cho thông báo
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, // Bỏ đường viền bóng
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

      shadowColor: Colors.blueAccent.withOpacity(0.5), // Màu bóng
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Màu nền
                    borderRadius: BorderRadius.circular(15.0), // Bo góc
                    border: Border.all(
                      color: Colors.grey, // Màu viền
                      width: 1.5, // Độ dày viền
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      style: TextStyle(color: Colors.black), // Màu chữ
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm công việc...',
                        border: InputBorder.none,

                        hintStyle:
                            TextStyle(color: Colors.grey[600]), // Màu gợi ý

                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                    : Icons.notifications_off_outlined,

                /// Icon thay đổi theo trạng thái
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 70,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          color: Colors.blueAccent, // Màu của đường viền dưới
          height: 2, // Độ dày của đường viền
        ),
      ),
    );
  }
}

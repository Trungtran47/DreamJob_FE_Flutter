// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dacn2/data/util/Util.dart';
// import 'package:dacn2/ui/applicant/messager/ApplicantListMessager.dart';
// import 'package:dacn2/data/services/user_service.dart';
// import 'package:dacn2/data/models/user.dart';
// import 'package:another_flushbar/flushbar.dart';

// class NotificationPage extends StatefulWidget {
//   NotificationPage({Key? key}) : super(key: key);

//   @override
//   NotificationPageState createState() => NotificationPageState();
// }

// class NotificationPageState extends State<NotificationPage> {
//   void reloadPage() {
//     setState(() {
//       // _loadMessages();
//     });
//   }

//   bool _notificationsEnabled = false; // Biến lưu trạng thái bật/tắt thông báo
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   Timer? _timer;
//   String? latestMessage = ""; // Biến lưu trữ tin nhắn mới nhất
//   late Future<User> futureUser;
//   final UserService userService = UserService(baseUrl: Util.baseUrl);

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _loadNotificationSetting();
//     futureUser = Future.error('Loading ...'); // Set initial value to error

//     // Gọi API tự động mỗi 10 giây nếu thông báo đã bật
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       if (_notificationsEnabled) {
//         _checkForUpdates();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // Hủy Timer khi không cần thiết
//     _timer?.cancel();
//     super.dispose();
//   }

//   // Cấu hình thông báo cục bộ
//   void _initializeNotifications() {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings('app_icon'),
//       iOS: DarwinInitializationSettings(),
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   // Tải trạng thái bật/tắt thông báo từ SharedPreferences
//   Future<void> _loadNotificationSetting() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
//     });
//   }

//   // Lưu trạng thái bật/tắt thông báo vào SharedPreferences
//   Future<void> _saveNotificationSetting(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('notifications_enabled', value);
//   }

//   // Hàm lấy dữ liệu từ API và kiểm tra có tin nhắn mới không
//   Future<void> _checkForUpdates() async {
//     final prefs = await SharedPreferences.getInstance();
//     final currentUserId = prefs.getInt('userId'); // Lấy userId hiện tại
//     if (currentUserId == null) {
//       print("User ID not found.");
//       return;
//     }
//     final response = await http.get(Uri.parse(Util.baseUrl +
//         '/user/message_detail/list/$currentUserId/$currentUserId'));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data.isNotEmpty) {
//         var newMessage = data['content'];
//         var newSendingTime = data['sendingTime'];
//         var newSenderId = data['userId'];
//         String previousMessage = prefs.getString('latest_message') ?? "";
//         if (newMessage != previousMessage) {
//           setState(() {
//             latestMessage = newMessage;
//           });
//           // Hiển thị thông báo cục bộ
//           _showNotification(newMessage, newSendingTime, newSenderId);
//           // Cập nhật tin nhắn mới vào SharedPreferences
//           await prefs.setString('latest_message', newMessage);
//         }
//       }
//     } else {
//       print('Failed to fetch updates');
//     }
//   }

//   void _showNotification(
//       String message, String sendingTime, int newSenderId) async {
//     User user = await userService.getUserById(newSenderId);

//     Flushbar(
//       title: 'Tin nhắn mới',
//       message: 'Bạn nhận được tin nhắn từ ${user.fullName}',
//       icon: Icon(
//         Icons.message,
//         size: 28.0,
//         color: Colors.white,
//       ),
//       leftBarIndicatorColor: Colors.blueAccent,
//       duration: Duration(seconds: 5), // Hiển thị trong 5 giây
//       mainButton: TextButton(
//         onPressed: () {
//           // Chuyển hướng đến trang tin nhắn
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ListMessPage()),
//           );
//         },
//         child: Text(
//           'Xem',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       backgroundColor: Colors.blueAccent,
//       flushbarPosition: FlushbarPosition.TOP, // Hiển thị ở trên cùng
//       margin: EdgeInsets.all(10), // Khoảng cách từ cạnh màn hình
//       borderRadius: BorderRadius.circular(10), // Bo góc cho thông báo
//     ).show(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Thông báo"),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white,
//                 const Color.fromARGB(255, 149, 223, 255),
//                 Colors.lightBlueAccent.shade400,
//               ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//         ),
//         elevation: 4,
//         actions: [
//           // Thêm IconButton để bật/tắt thông báo
//           IconButton(
//             icon: Icon(
//               _notificationsEnabled
//                   ? Icons.notifications_active
//                   : Icons.notifications_off,
//             ),
//             onPressed: () {
//               setState(() {
//                 _notificationsEnabled = !_notificationsEnabled;
//                 _saveNotificationSetting(_notificationsEnabled);
//               });
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: _notificationsEnabled
//             ? Text(
//                 "Thông báo đang bật, bạn sẽ nhận thông báo mới.",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               )
//             : Text(
//                 "Thông báo đang tắt.",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//       ),
//     );
//   }
// }

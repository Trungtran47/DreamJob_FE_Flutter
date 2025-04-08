import 'package:dacn2/data/services/message_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import '../../../data/models/response/postResponse.dart';
import 'package:dacn2/ui/applicant/messager/ApplicantChat.dart';
import 'package:dacn2/data/models/message_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/services/message_service.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/models/request/savedJobRequest.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/services/save_job.dart';

class JobDetail extends StatefulWidget {
  final PostResponse postResponse;
  JobDetail({required this.postResponse});

  @override
  State<JobDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<JobDetail>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final MessageService messageService = MessageService(baseUrl: Util.baseUrl);
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  final TextEditingController _contentController = TextEditingController();
  late AnimationController _controller;
  late int userId;
  late Future<User> futureUser;
  final SavedJobService savedJobService =
      SavedJobService(baseUrl: Util.baseUrl);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadUser();
  }

  Future<User?> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final user = await userService.getUserById(userId);
      return user;
    } else {
      throw Exception('User ID not found');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _createMessage(BuildContext context) async {
    print("Hàm _createMessage đã được gọi"); // Kiểm tra gọi hàm

    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final user = await _loadUser();
      if (userId == null) {
        print('User ID is null');
        return;
      }
      if (user == null) {
        print('User is null');
        return;
      }
      // Tạo MessageRequest từ dữ liệu có sẵn
      final messageRequest = MessageRequest(
        applicantId: user.userId,
        applicantName: user.username,
        employerId: widget.postResponse.userId,
        employerName: widget.postResponse.username,
        avatarChat: widget.postResponse.companyLogo,
        messageDetails: [
          MessageDetail(
            userId: user.userId,
            content: user.fullName +
                ' đã gửi yêu cầu ứng tuyển việc làm về bài post: ' +
                widget.postResponse.title +
                ' của bạn hãy xem thêm thông tin của ' +
                user.fullName +
                ' biết thêm thông tin.(Tin nhắn tự động)',
            cv: user.cv,
            sendingTime: DateTime.now()
                .toIso8601String(), // Chuyển đổi thời gian thành ISO string
          ),
          MessageDetail(
            userId: user.userId,
            content: _contentController.text,

            cv: user.cv,
            sendingTime: DateTime.now()
                .toIso8601String(), // Chuyển đổi thời gian thành ISO string
          ),
        ],
      );

      final messageResponse =
          await messageService.createMessage(messageRequest);
      if (messageResponse != null) {
        print('Tin nhắn đã gửi thành công'); // Ghi log khi gửi thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tin nhắn đã được gửi thành công!')),
        );
        Navigator.of(context).pop();
      } else {
        print('Không thể gửi tin nhắn'); // Ghi log khi lỗi xảy ra
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi tin nhắn, vui lòng thử lại!')),
        );
      }
    }
  }

  Future<void> _saveJob(
      BuildContext context, bool isSaved, Function(bool) setState) async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    final savedJobRequest = SavedJobRequest(
      id: 0,
      userId: userIdFromPrefs!,
      postId: widget.postResponse.postId,
    );
    try {
      final savedJobResponse = await savedJobService.saveJob(savedJobRequest);
      setState(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Lưu bài ' + widget.postResponse.title + ' thành công!'),
          behavior: SnackBarBehavior.floating, // Để snackbar nổi lên
          margin: EdgeInsets.fromLTRB(20, kToolbarHeight + 10, 20,
              20), // Kích thước của AppBar và khoảng cách
          duration: Duration(seconds: 1), // Thời gian hiển thị
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save job: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.postResponse;
    return Scaffold(
        appBar: AppBar(
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
          title: Text(post.title),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // More options action
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // Bọc SingleChildScrollView với Expanded
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: post.logoUrl.isNotEmpty
                                      ? NetworkImage(post.logoUrl)
                                      : AssetImage('images/default_profile.png')
                                          as ImageProvider,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  post.companyName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildIconText(
                                        Icons.attach_money, post.salary),
                                    _buildIconText(
                                        Icons.location_on, post.location),
                                    _buildIconText(Icons.star, post.experience),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Divider(),
                                _buildInfoRow('Hình thức', post.employmentType),
                                _buildInfoRow('Số lượng tuyển',
                                    post.vacancies.toString()),
                                // _buildInfoRow('Lương', post.salary),
                                _buildInfoRow('Vị trí', post.level),
                                _buildInfoRow('Kinh nghiệm', post.experience),
                                _buildInfoRow('Giới tính', post.gender),
                                _buildInfoRow(
                                    'Giờ làm việc', post.workingHours),

                                _buildInfoRow(
                                    'Ngày hết hạn', post.getDaysRemaining()),
                                Divider(),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle("Địa điểm làm việcc"),
                                    _buildDynamicText(
                                        post.workLocation), // Hiển thị động
                                    _buildSectionTitle("Mô tả công việc"),
                                    _buildDynamicText(
                                        post.jobDescription), // Hiển thị động
                                    SizedBox(height: 16),

                                    _buildSectionTitle("Quyền lợi"),
                                    _buildDynamicText(post.benefits),
                                    SizedBox(height: 16),

                                    _buildSectionTitle("Yêu cầu"),
                                    _buildDynamicText(
                                        post.applicationRequirements),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Gửi tin nhắn đến nhà tuyển dụng'),
                              content: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FutureBuilder<User?>(
                                        future: _loadUser(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.data?.cv ==
                                                  null ||
                                              snapshot.data?.cv == '') {
                                            return const Text(
                                              'Bạn chưa cập nhật CV',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              'CV của bạn sẽ được gửi đến nhà tuyển dụng',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          }
                                        },
                                      ),

                                      // const Text(
                                      //   'CV của bạn sẽ được gửi đến nhà tuyển dụng',
                                      //   style: TextStyle(
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller: _contentController,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          hintText: 'Nhập tin nhắn của bạn',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Vui lòng nhập tin nhắn';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Xử lý gửi tin nhắn đến employer
                                      _createMessage(context);
                                    }
                                  },
                                  child: Text('Gửi'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                        backgroundColor: Color.fromARGB(255, 102, 190, 234),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Ứng tuyển ngay'),
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        bool isSaved = false;
                        return IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_outline,
                          ),
                          onPressed: () =>
                              _saveJob(context, isSaved, (bool value) {
                            setState(() {
                              isSaved = value;
                            });
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildIconText(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 45, 97, 201), size: 28),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}

Widget _buildDynamicText(String content) {
  // Kiểm tra nội dung dài hay ngắn
  bool isLongContent = content.length > 50; // Ví dụ: dài hơn 50 ký tự

  return Container(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
        height: 1.5,
        fontWeight: isLongContent
            ? FontWeight.normal
            : FontWeight.bold, // Nội dung ngắn có thể in đậm
      ),
      textAlign: TextAlign.left, // Luôn căn lề trái
    ),
  );
}

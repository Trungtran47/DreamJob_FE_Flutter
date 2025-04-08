import 'package:flutter/material.dart';
import '../../../data/models/response/postResponse.dart';

class PostDetail extends StatefulWidget {
  final PostResponse postResponse;
  PostDetail({required this.postResponse});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                                  style: TextStyle(
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
                                    SizedBox(height: 16),
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
                ElevatedButton(
                  onPressed: () {
                    // Apply button action
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    backgroundColor:
                        Color.fromARGB(255, 102, 190, 234), // Đặt màu nền ở đây
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Ứng tuyển ngay'),
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

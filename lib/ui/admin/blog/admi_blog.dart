import 'package:dacn2/data/models/blog.dart';
import 'package:dacn2/data/services/blog_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/admin/blog/admin_blog_detail.dart';
import 'package:dacn2/ui/admin/custom/slidemenu.dart';
import 'package:flutter/material.dart';

class AdminBlogPage extends StatefulWidget {
  @override
  _AdminBlogPageState createState() => _AdminBlogPageState();
}

class _AdminBlogPageState extends State<AdminBlogPage> {
  final BlogService _adminBlogService = BlogService(baseUrl: Util.baseUrl);
  late List<Blog> _blogs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBlogsByStatus(); // Lấy blog có trạng thái "Đang hoạt động"
  }

  Future<void> _fetchBlogsByStatus() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final blogs = await _adminBlogService.getAllBlogsNoStatus();
      setState(() {
        _blogs = blogs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  // Phương thức để tải lại dữ liệu khi vuốt xuống
  Future<void> _refreshData() async {
    await _fetchBlogsByStatus(); // Tải lại blog theo trạng thái hiện tại
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Danh sách Blog'),
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
          : RefreshIndicator(
              onRefresh: _refreshData, // Kéo xuống để tải lại dữ liệu
              child: ListView.builder(
                itemCount: _blogs.length,
                itemBuilder: (context, index) {
                  final blog = _blogs[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            blog.imageUrl), // Hình ảnh đại diện blog
                      ),
                      title: Text(
                        blog.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        blog.author!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: _buildStatusChip(blog.status!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminBlogDetailPage(blog: blog)),
                        );
                        setState(() {
                          _fetchBlogsByStatus();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  // Xử lý hiển thị trạng thái đẹp hơn với màu sắc
  Widget _buildStatusChip(int status) {
    Color color;
    String label;

    switch (status) {
      case 0:
        color = Colors.green;
        label = 'Đang hoạt động';
        break;
      case 1:
        color = Colors.orange;
        label = 'Đang chờ duyệt';
        break;
      case -1:
        color = Colors.red;
        label = 'Hết hoạt động';
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

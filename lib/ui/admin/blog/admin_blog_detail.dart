import 'package:dacn2/data/services/blog_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/blog.dart';

class AdminBlogDetailPage extends StatelessWidget {
  final Blog blog;

  AdminBlogDetailPage({required this.blog});

  final BlogService _adminBlogService = BlogService(baseUrl: Util.baseUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text('${blog.title}'),
        // tao icon de chinh sua status cua blog
        actions: [
          blog.status == 0
              ? TextButton(
                  child: Text('Đã duyệt'),
                  onPressed: () async {
                    bool? confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Xác nhận'),
                          content:
                              Text('Bạn có chắc chắn muốn ẩn blog này không?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Hủy'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('Đồng ý'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm == true) {
                      await _adminBlogService.updateStatusBlog(blog.blogId!, 1);
                      Navigator.pop(context);
                    }
                  },
                )
              : TextButton(
                  child: Text('Chưa duyệt'),
                  onPressed: () async {
                    bool? confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Xác nhận'),
                          content: Text(
                              'Bạn có chắc chắn muốn duyệt blog này không?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Hủy'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('Đồng ý'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm == true) {
                      await _adminBlogService.updateStatusBlog(blog.blogId!, 0);
                      Navigator.pop(context);
                    }
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.image != null)
              Center(
                child: Image.network(
                  blog.imageUrl!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 200,
                  ),
                ),
              ),
            SizedBox(height: 16),
            Text(
              blog.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (blog.author != null)
              Text(
                '${blog.author}',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            if (blog.time != null)
              Text(
                blog.getDays(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            Divider(height: 32, thickness: 1),
            Text(
              blog.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

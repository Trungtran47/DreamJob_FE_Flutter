import 'package:dacn2/data/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/blog.dart';
import 'BlogDetail.dart';

// Job Card Widget
class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback onShare;
  BlogCard({required this.blog, required this.onShare});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlogDetailPage(blog: blog)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (blog.image != null) // Hiển thị ảnh nếu có
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    blog.imageUrl,
                    width: double.infinity, // Chiều rộng ảnh chiếm toàn bộ
                    height: 100, // Đặt chiều cao phù hợp
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 5),
              Text(
                blog.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                blog.content,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              Divider(color: Colors.grey.shade300), // Đường kẻ ngăn cách

              // Wrap this section in a Stack to use Positioned widget correctly
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: onShare,
                        icon: Icon(Icons.share, color: Colors.blue),
                        label: Text('Share'),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          blog.getDayApplicant(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

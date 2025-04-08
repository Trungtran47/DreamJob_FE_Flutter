import 'package:dacn2/data/services/blog_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/applicant/blog/BlogCarD.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/blog.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late Future<List<Blog>> futureBlogs = Future.value([]);
  final BlogService blogService = BlogService(baseUrl: Util.baseUrl);

  Future<List<Blog>> _getBlogs() async {
    setState(() {
      futureBlogs = blogService.getAllBlogs();
    });
    return futureBlogs;
  }

  @override
  void initState() {
    super.initState();
    _getBlogs();
  }

  @override
  Widget build(BuildContext conext) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<Blog>>(
          future: futureBlogs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có blog nào'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return BlogCard(
                    blog: snapshot.data![index],
                    onShare: () {
                      // Share blog
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

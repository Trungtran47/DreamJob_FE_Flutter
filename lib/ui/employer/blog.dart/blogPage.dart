import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/applicant/home/Home.dart';
import 'package:dacn2/ui/employer/blog.dart/UpdateBlog.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/blog.dart';
import 'blogCard.dart';
import 'package:dacn2/data/services/blog_service.dart ';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/ui/employer/home/EmployerHome.dart';
import 'CreateBlog.dart';

class BlogListPage extends StatefulWidget {
  BlogListPage({Key? key}) : super(key: key);
  @override
  BlogListPageState createState() => BlogListPageState();
}

class BlogListPageState extends State<BlogListPage> {
  void reloadPage() {
    _getBlogs();
  }

  final BlogService blogService = BlogService(baseUrl: Util.baseUrl);
  late Future<List<Blog>> futureBlogs = Future.value([]);
  late int userId;
  @override
  void initState() {
    super.initState();
    _getBlogs();
  }

  Future<List<Blog>> _getBlogs() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        futureBlogs = blogService.getBlogs(userIdFromPrefs);
      });
    } else {
      setState(() {
        futureBlogs = Future.error('User id not found');
      });
    }
    return futureBlogs;
  }

  void onLike(Blog blog) {
    print('Liked: ${blog.title}');
  }

  void onShare(Blog blog) {
    print('Shared: ${blog.title}');
  }

  void onReadMore(Blog blog) {
    print('Read More: ${blog.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Blogs'),
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
        actions: [
          ElevatedButton(
              child: Text(
                'Thêm blog',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBlog(),
                  ),
                );
                if (result != null) {
                  reloadPage(); // Làm mới Future
                }
              }),
        ],
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
              return Center(child: Text('Bạn không có blog nào'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return BlogCard(
                    blog: snapshot.data![index],
                    onDelete: () {
                      setState(() {
                        snapshot.data!.removeAt(index);
                      });
                    },
                    onUpdate: () {
                      final result = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateBlog(
                            blog: snapshot.data![index],
                          ),
                        ),
                      );
                      result.then((value) {
                        if (value != null) {
                          reloadPage();
                        }
                      });
                    },
                    onLike: () => onLike(snapshot.data![index]),
                    onShare: () => onShare(snapshot.data![index]),
                    onReadMore: () => onReadMore(snapshot.data![index]),
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

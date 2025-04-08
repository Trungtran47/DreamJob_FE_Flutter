import 'package:dacn2/data/models/blog.dart';
import 'package:dacn2/ui/applicant/blog/BlogCarD.dart';
import 'package:flutter/material.dart';

class CompanyBlogPage extends StatelessWidget {
  final Future<List<Blog>> futureBlogs;

  CompanyBlogPage({required this.futureBlogs});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Blog>>(
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
    );
  }
}

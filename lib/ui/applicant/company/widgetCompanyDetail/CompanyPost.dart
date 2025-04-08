import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/ui/applicant/job/JobCart.dart';
import 'package:flutter/material.dart';

class CompanyPostsPage extends StatelessWidget {
  final Future<List<PostResponse>> futurePosts;

  CompanyPostsPage({required this.futurePosts});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostResponse>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài tuyển dụng nào.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return JobCart(postResponse: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}

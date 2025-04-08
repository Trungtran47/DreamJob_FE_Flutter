import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/ui/applicant/job/JobCart.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/services/post_service.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  late Future<List<PostResponse>> futurePosts;
  final PostService postService = PostService(baseUrl: Util.baseUrl);
  late List<PostResponse> filteredPosts;
  String searchQuery = '';
  late int userId;
  @override
  void initState() {
    super.initState();
    futurePosts = Future.error('Loading ...'); // Set initial value to error
    _loadListJobs();
    futurePosts = postService.getAllPosts(); // Lấy dữ liệu khi khởi tạo
  }

  Future<void> _loadListJobs() async {
    setState(() {
      futurePosts = postService.getAllPosts();
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      futurePosts.then((posts) {
        filteredPosts = posts.where((post) {
          return (post.title.toLowerCase().contains(query.toLowerCase())) ||
              (post.location.toLowerCase().contains(query.toLowerCase())) ||
              (post.salary.toLowerCase().contains(query.toLowerCase())) ||
              (post.experience.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm job',
              border: InputBorder.none,
              icon: Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        updateSearchQuery('');
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<PostResponse>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có bài post nào'));
          } else {
            // Lọc danh sách dựa trên `searchQuery`
            final List<PostResponse> filteredPosts =
                snapshot.data!.where((post) {
              return post.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  post.location
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  post.salary
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  post.experience
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
            }).toList();

            if (filteredPosts.isEmpty) {
              return Center(child: Text('Không tìm thấy bài đăng phù hợp'));
            }

            return ListView.builder(
              itemCount: filteredPosts
                  .length, // Hiển thị số lượng phần tử trong `filteredPosts`
              itemBuilder: (context, index) {
                return JobCart(
                    postResponse:
                        filteredPosts[index]); // Hiển thị các bài đăng đã lọc
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:dacn2/data/models/blog.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/data/services/company_service.dart';
import 'package:dacn2/data/services/post_service.dart';
import 'package:dacn2/data/services/blog_service.dart';

import 'widgetCompanyDetail/CompanyBlog.dart';
import 'widgetCompanyDetail/CompanyPost.dart';

class CompanyInfoPage extends StatefulWidget {
  final Company company;

  CompanyInfoPage({required this.company}); // Constructor

  @override
  _CompanyInfoPageState createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  int _selectedIndex = 0;
  late Future<List<PostResponse>> futurePosts;
  late Future<List<Blog>> futureBlogs;
  final CompanyService companyService = CompanyService(baseUrl: Util.baseUrl);
  final PostService postService = PostService(baseUrl: Util.baseUrl);
  final BlogService blogService = BlogService(baseUrl: Util.baseUrl);

  Future<void> _loadPosts() async {
    setState(() {
      futurePosts = postService.getAllPostsByUserId(widget.company.user!);
    });
    futurePosts.then((posts) {
      print('Posts loaded: $posts');
    }).catchError((error) {
      print('Error loading posts: $error');
    });
  }

  Future<void> _loadBlogs() async {
    setState(() {
      futureBlogs = blogService.getBlogs(widget.company.user!);
    });
    futureBlogs.then((blogs) {
      print('Blogs loaded: $blogs');
    }).catchError((error) {
      print('Error loading blogs: $error');
    });
  }

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _loadBlogs();

    print('thông SZJDpsjdadpoaksp $futurePosts'); // Kiểm tra Future object
    print('ahfousnwneiosodcmo $futureBlogs'); // Kiểm tra Future object
    _pages = [
      CompanyPostsPage(futurePosts: futurePosts),
      CompanyBlogPage(futureBlogs: futureBlogs),
    ];
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
                Colors.white,
                Color(0xFFB3E5FC), // Xanh nhạt nhẹ ở giữa
                Color(0xFF039BE5), // Xanh đậm hơn ở dưới
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: Text('${widget.company.companyName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Material(
                          elevation: 2.0, // Độ nổi của hiệu ứng
                          borderRadius: BorderRadius.circular(15), // Bo góc
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                15), // Tương tự bán kính của bo góc
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  widget.company.companyLogo.isNotEmpty
                                      ? NetworkImage(widget.company.logoUrl)
                                      : const AssetImage(
                                              'images/default_profile.png')
                                          as ImageProvider,
                            ),
                          ),
                        ),
                        Text(
                          widget.company.companyName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildCompanyDetailRow(Icons.business,
                            " Loại công ty : ", widget.company.companyCategory),
                        _buildCompanyDetailRow(Icons.web, " Website : ",
                            widget.company.companyWebsite),
                        _buildCompanyDetailRow(
                            Icons.people,
                            " Số lượng nhân viên : ",
                            widget.company.companySize),
                        _buildCompanyDetailRow(Icons.location_on, " Địa chỉ : ",
                            widget.company.companyLocation),
                        _buildCompanyDetailRow(
                            Icons.info,
                            " Thông tin công ty : ",
                            widget.company.companyIntroduce),
                      ],
                    ),
                  ),
                  // Divider(),
                ],
              ),
            ),
          ),
          // Thanh Điều Hướng Tùy Chỉnh
          Row(
            // mainAxisAl
            //ignment: MainAxisAlignment.center,

            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.post_add,
                  color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                ),
                label: Text(
                  'Bài tuyển dụng',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 20),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.article,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                ),
                label: Text(
                  'Blog',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          // Nội dung tab hiện tại
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  // Helper method to avoid repetitive code for building company info rows
  Widget _buildCompanyDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

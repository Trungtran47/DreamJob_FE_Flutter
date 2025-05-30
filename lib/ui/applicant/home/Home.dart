import 'package:dacn2/data/services/post-recommended.dart';
import 'package:dacn2/ui/applicant/job/JobCart.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/ui/applicant/home/company/topcompanies.dart';
import 'category/Categoryicon.dart';
import 'package:dacn2/ui/applicant/appbar/AppBar.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/services/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/data/services/company_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  void reloadPage() {
    setState(() {
      // _loadCompanies();
      // _loadUser();
      _loadListJobs();
      _loadListJobAtt();
      _loadListJobSugg();
    });
  }

  late Future<List<Company>> futureCompanies;
  final CompanyService companyService = CompanyService(baseUrl: Util.baseUrl);
  late Future<User> futureUser;
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  late Future<List<PostResponse>> futurePosts;
  late Future<List<PostResponse>> futurePostAtt;
  late Future<List<PostResponse>> futurePostSugg;
  final PostService postService = PostService(baseUrl: Util.baseUrl);
  final RecommendedService recommendedService =
      RecommendedService(baseUrl: Util.baseUrl);
  late int userId;
  @override
  void initState() {
    super.initState();
    futurePosts = Future.error('Loading ...'); // Set initial value to error
    futurePostAtt = Future.error('Loading ...'); // Set initial value to error
    futureUser = Future.error('Loading ...');
    futurePostSugg = Future.error('Loading ...');
    // futureCompanies = Future.error('Loading ...');
    // _loadCompanies();
    // _loadUser();
    _loadListJobs();
    _loadListJobAtt();
    _loadListJobSugg();
  }

  Future<List<PostResponse>> _loadListJobs() async {
    List<PostResponse> allPosts = await postService.getAllPosts();
    List<PostResponse> limitedPosts = allPosts.take(4).toList();
    setState(() {
      futurePosts = Future.value(
          limitedPosts); // Cập nhật lại futurePosts với danh sách giới hạn
    });
    return limitedPosts;
  }

  Future<List<PostResponse>> _loadListJobAtt() async {
    List<PostResponse> allPosts = await postService.getAllPosts();
    allPosts.sort(
        (a, b) => _extractSalary(b.salary).compareTo(_extractSalary(a.salary)));
    List<PostResponse> limitedPosts = allPosts.take(4).toList();
    setState(() {
      futurePostAtt = Future.value(limitedPosts);
    });
    return limitedPosts;
  }

// Hàm chuyển đổi chuỗi lương sang giá trị số để so sánh
  int _extractSalary(String salary) {
    if (salary.toLowerCase().contains('dưới')) {
      return int.tryParse(salary.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    } else if (salary.contains('-')) {
      List<String> parts = salary.split('-');
      int minSalary =
          int.tryParse(parts[0].replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      int maxSalary =
          int.tryParse(parts[1].replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return ((minSalary + maxSalary) / 2).round();
    } else {
      return int.tryParse(salary.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    }
  }

  // Future<List<PostResponse>> _loadListJobSugg() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userIdFromPrefs = prefs.getInt('userId');
  //   if (userIdFromPrefs == null) {
  //     throw Exception('User ID not found');
  //   }
  //   User user = await userService.getUserById(userIdFromPrefs);
  //   String userLocation = user.location; // Vị trí của người dùng
  //   String favoriteIndustries = user.desiredJob; // Ngành yêu thích
  //   List<PostResponse> allPosts = await postService.getAllPosts();
  //   List<PostResponse> filteredPosts = allPosts.where((job) {
  //     return job.location == userLocation ||
  //         favoriteIndustries.contains(job.title);
  //   }).toList();
  //   if (filteredPosts.length < 4) {
  //     List<PostResponse> additionalPosts = allPosts
  //         .where((job) => !filteredPosts.contains(job))
  //         .take(4 - filteredPosts.length)
  //         .toList();
  //     filteredPosts.addAll(additionalPosts);
  //   }
  //   List<PostResponse> limitedPosts = filteredPosts.take(4).toList();
  //   setState(() {
  //     futurePostSugg = Future.value(limitedPosts);
  //   });
  //   return limitedPosts;
  // }
  Future<List<PostResponse>> _loadListJobSugg() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs == null) {
      throw Exception('User ID not found');
    }
    List<PostResponse> allPosts =
        await recommendedService.getPostRecommendByUserId(userIdFromPrefs);
    List<PostResponse> limitedPosts = allPosts.take(4).toList();
    setState(() {
      futurePostSugg = Future.value(limitedPosts);
    });
    return limitedPosts;
    // // 1. Gửi request đến Flask API
    // final recommendedIds =
    //     await recommendedService.getPostRecommendByUserId(userIdFromPrefs);

    // setState(() {
    //   futurePostSugg = Future.value(recommendedIds);
    //   print('futurePostSugg: $futurePostSugg');
    // });
    // return recommendedIds;
  }

  // Future<void> _loadCompanies() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userIdFromPrefs = prefs.getInt('userId');
  //   if (userIdFromPrefs != null) {
  //     List<Company> allCompanies = await companyService.getAllCompanies();
  //     List<Company> limitedCompanies = allCompanies.take(4).toList();
  //     setState(() {
  //       futureCompanies = Future.value(limitedCompanies);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sử dụng CategoryIcon trong Padding
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryIcon(
                      imagePath: 'images/logo_job.png',
                      label: 'Việc làm',
                      routeName: '/jobs', // Tên route cho trang việc làm
                    ),
                    CategoryIcon(
                      imagePath: 'images/logo_company.png',
                      label: 'Công ty',
                      routeName: '/companies', // Tên route cho trang công ty
                    ),
                    CategoryIcon(
                      imagePath: 'images/logo_blog.png',
                      label: 'Blog',
                      routeName: '/blog', // Tên route cho trang blog
                    ),
                    CategoryIcon(
                      imagePath: 'images/logo_congcu.png',
                      label: 'Công cụ',
                      routeName: '/tools', // Tên route cho trang công cụ
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gợi ý việc làm',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<List<PostResponse>>(
                      future: futurePostSugg,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('Không có bài post nào'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return JobCart(
                                postResponse: snapshot.data![index],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Latest Job Listings
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Việc làm mới nhất',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<List<PostResponse>>(
                      future: futurePosts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('Không có bài post nào'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return JobCart(
                                postResponse: snapshot.data![index],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              // More Jobs Section (Static List)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Việc làm hấp dẫn',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<List<PostResponse>>(
                      future: futurePostAtt,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('Không có bài post nào'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return JobCart(
                                postResponse: snapshot.data![index],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Top công ty hàng đầu',
              //         style:
              //             TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //       ),
              //       FutureBuilder<List<Company>>(
              //         future: futureCompanies,
              //         builder: (context, snapshot) {
              //           if (snapshot.connectionState ==
              //               ConnectionState.waiting) {
              //             return const Center(
              //                 child: CircularProgressIndicator());
              //           } else if (snapshot.hasError) {
              //             return Center(
              //                 child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
              //           } else if (!snapshot.hasData ||
              //               snapshot.data!.isEmpty) {
              //             return const Center(
              //                 child: Text('Không có công ty nào để hiển thị.'));
              //           } else {
              //             List<Company> companies = snapshot.data!;
              //             return Padding(
              //               padding:
              //                   const EdgeInsets.symmetric(horizontal: 8.0),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   const Text(
              //                     'Top công ty hàng đầu',
              //                     style: TextStyle(
              //                         fontSize: 18,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                   GridView.builder(
              //                     shrinkWrap: true,
              //                     physics: const NeverScrollableScrollPhysics(),
              //                     gridDelegate:
              //                         const SliverGridDelegateWithFixedCrossAxisCount(
              //                       crossAxisCount: 2, // 2 cột
              //                       childAspectRatio:
              //                           0.8, // Tỉ lệ chiều ngang và cao
              //                       crossAxisSpacing: 10, // Khoảng cách cột
              //                       mainAxisSpacing: 10, // Khoảng cách hàng
              //                     ),
              //                     itemCount: companies.length,
              //                     itemBuilder: (context, index) {
              //                       final company = companies[index];
              //                       return TopCompany(company: company);
              //                     },
              //                   ),
              //                 ],
              //               ),
              //             );
              //           }
              //         },
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

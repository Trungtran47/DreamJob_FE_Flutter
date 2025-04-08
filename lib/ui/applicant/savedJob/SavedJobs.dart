import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'jobCartSaved.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/services/save_job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedJobsPage extends StatefulWidget {
  SavedJobsPage({Key? key}) : super(key: key);
  @override
  SavedJobsPageState createState() => SavedJobsPageState();
}

class SavedJobsPageState extends State<SavedJobsPage> {
  void reloadPage() {
    setState(() {
      _loadListJobs();
    });
  }

  late Future<List<PostResponse>> futurePosts;
  final SavedJobService saveJob = SavedJobService(baseUrl: Util.baseUrl);
  late List<PostResponse> filteredPosts;
  String searchQuery = '';
  late int userId;
  @override
  void initState() {
    super.initState();
    futurePosts = Future.error('Loading ...'); // Set initial value to error
    _loadListJobs();
  }

  Future<void> _loadListJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        futurePosts = saveJob.getAllSavedJobs(userId);
      });
    } else {
      setState(() {
        futurePosts = Future.error('User ID not found');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Công việc đã lưu'),
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
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(posts[index]
                      .postId
                      .toString()), // Sử dụng ID bài post làm khóa
                  direction:
                      DismissDirection.endToStart, // Vuốt từ phải sang trái
                  onDismissed: (direction) async {
                    // Gọi API hoặc xử lý logic xóa
                    final postToDelete = posts[index];
                    try {
                      await saveJob.deleteSavedJob(userId, postToDelete.postId);
                      setState(() {
                        posts.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Đã xóa  ${postToDelete.title}')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi khi xóa công việc: $e')),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: JobCart(
                    postResponse: posts[index],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

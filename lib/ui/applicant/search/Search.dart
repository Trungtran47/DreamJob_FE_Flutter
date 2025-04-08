import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/services/post_service.dart';
import 'package:dacn2/ui/applicant/job/JobCart.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'ggMap.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _searchQuery = "";
  late Future<List<PostResponse>> futurePosts;
  final PostService postService = PostService(baseUrl: Util.baseUrl);
  late List<PostResponse> filteredPosts = [];
  String? _selectedLocation; // Biến lưu trữ địa điểm được chọn
  List<String> locations = []; // Danh sách địa điểm
  final TextEditingController _searchController =
      TextEditingController(); // Thêm TextEditingController

  @override
  void initState() {
    super.initState();
    _speech.initialize();
    futurePosts = postService.getAllPosts();
    // Lấy danh sách địa điểm sau khi tải bài viết
    futurePosts.then((posts) {
      getLocations(posts);
    });
  }

  // Hàm bắt đầu và dừng ghi âm giọng nói
  void _toggleListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    } else {
      setState(() {
        _isListening = true;
      });
      bool available = await _speech.listen(onResult: (result) {
        setState(() {
          _searchQuery = result.recognizedWords;
          _searchController.text = _searchQuery; // Cập nhật TextField
        });
        updateSearchQuery(_searchQuery);
      });
      if (!available) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  // Hàm chuẩn hóa và loại bỏ dấu
  String removeAccents(String text) {
    return unorm
        .nfd(text)
        .replaceAll(RegExp(r'\p{Mn}', unicode: true), '')
        .replaceAll(RegExp(r'\p{Mn}', unicode: true), '');
  }

  // Hàm cập nhật kết quả tìm kiếm theo từ khóa và địa điểm
  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      futurePosts.then((posts) {
        filteredPosts = posts.where((post) {
          bool matchesSearchQuery = removeAccents(post.title.toLowerCase())
                  .contains(removeAccents(query.toLowerCase())) ||
              removeAccents(post.location.toLowerCase())
                  .contains(removeAccents(query.toLowerCase())) ||
              removeAccents(post.salary.toLowerCase())
                  .contains(removeAccents(query.toLowerCase())) ||
              removeAccents(post.experience.toLowerCase())
                  .contains(removeAccents(query.toLowerCase()));

          // Nếu có địa điểm được chọn, lọc theo địa điểm đó
          if (_selectedLocation != null && _selectedLocation!.isNotEmpty) {
            return matchesSearchQuery &&
                post.location.toLowerCase() == _selectedLocation!.toLowerCase();
          }

          return matchesSearchQuery;
        }).toList();
      });
    });
  }

  // Hàm cập nhật danh sách địa điểm
  void getLocations(List<PostResponse> posts) {
    Set<String> locationSet = Set();
    for (var post in posts) {
      locationSet.add(post.location);
    }
    setState(() {
      locations = locationSet.toList();
      locations.sort(); // Sắp xếp địa điểm để dễ chọn
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
                Colors.white,
                const Color.fromARGB(255, 149, 223, 255),
                Colors.lightBlueAccent.shade400,
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController, // Sử dụng controller
                  onChanged: updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm công việc...', // Hiển thị khi trống
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              updateSearchQuery('');
                              _searchController
                                  .clear(); // Xóa nội dung TextField
                            },
                          )
                        : null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.blueAccent,
                ),
                onPressed: _toggleListening,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Chọn địa điểm",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                        ),
                        value: _selectedLocation,
                        items: locations.map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLocation = value;
                          });
                          updateSearchQuery(_searchQuery);
                        },
                      ),
                      if (_selectedLocation !=
                          null) // Hiển thị nút "Xóa" khi có giá trị
                        Positioned(
                          right: 30, // Căn phải
                          child: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _selectedLocation = null; // Xóa giá trị
                              });
                              updateSearchQuery(_searchQuery);
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Image.asset(
                    'images/map.png',
                    width: 28, // Adjust the width
                    height: 28, // Adjust the height
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => GoogleMapPage()),
                    // );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<PostResponse>>(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có bài đăng nào.'));
                  } else {
                    // Dữ liệu đã được lọc từ updateSearchQuery
                    return ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        return JobCart(postResponse: filteredPosts[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _speech.stop();
  }
}

import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'JobDetail.dart';
import '../../../data/services/save_job.dart';
import '../../../data/models/request/savedJobRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Job Card Widget
class JobCart extends StatelessWidget {
  final PostResponse postResponse;
  // final Function onSave;
  JobCart({required this.postResponse}); // Constructor
  final SavedJobService savedJobService =
      SavedJobService(baseUrl: Util.baseUrl);

  Future<void> _saveJob(
      BuildContext context, bool isSaved, Function(bool) setState) async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    final savedJobRequest = SavedJobRequest(
      id: 0,
      userId: userIdFromPrefs!,
      postId: postResponse.postId,
    );
    try {
      if (postResponse.getDaysRemaining() ==
          'Bài viết đã hết thời gian tuyển dụng') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bài viết đã hết thời gian tuyển dụng')),
        );
        return;
      }
      final savedJobResponse = await savedJobService.saveJob(savedJobRequest);
      setState(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu ${postResponse.title}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save job: $e')),
      );
    }
  }

  String _splitText(String text, int maxLength) {
    final buffer = StringBuffer();
    int start = 0;
    while (start < text.length) {
      // Tìm đoạn có độ dài tối đa là maxLength
      int end = start + maxLength;
      // Nếu vượt quá độ dài chuỗi, cắt đến cuối chuỗi
      if (end >= text.length) {
        buffer.write(text.substring(start));
        break;
      }
      // Nếu không, tìm khoảng trắng cuối cùng trong đoạn maxLength
      int lastSpace = text.lastIndexOf(' ', end);
      if (lastSpace > start) {
        buffer.write(text.substring(start, lastSpace));
        buffer.writeln(); // Thêm xuống dòng
        start = lastSpace + 1; // Bỏ qua khoảng trắng
      } else {
        // Nếu không tìm thấy khoảng trắng, cắt tại maxLength
        buffer.write(text.substring(start, end));
        buffer.writeln();
        start = end;
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JobDetail(postResponse: postResponse)),
          );
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey, // Màu sắc của đường viền
                  width: 1.5, // Độ dày của đường viền
                ),
              ),
              child: Column(
                // Sử dụng Column để tổ chức các thành phần bên trong
                children: [
                  Stack(
                    children: [
                      // Sử dụng Container để chứa Row
                      Container(
                        // padding: const EdgeInsets.only(
                        //     top: 5, right: 5), // Thêm padding nếu cần
                        child: Row(
                          children: [
                            // Logo công ty
                            Material(
                              elevation: 2.0, // Độ nổi của hiệu ứng
                              borderRadius: BorderRadius.circular(15), // Bo góc
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    15), // Tương tự bán kính của bo góc
                                onTap: () {
                                  // Xử lý sự kiện nhấn (nếu cần)
                                  print('Image tapped');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15), // Bo góc cho hình vuông
                                  child: postResponse.logoUrl.isNotEmpty
                                      ? Image.network(
                                          postResponse.logoUrl,
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'images/default_profile.png',
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    5), // Khoảng cách ngang giữa logo và nội dung
                            // Flexible cho phần thông tin công việc
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _splitText(postResponse.title, 25),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines:
                                        2, // Giới hạn số dòng (ở đây là 1 dòng)
                                    overflow: TextOverflow
                                        .ellipsis, // Thêm dấu "..." khi chữ vượt quá giới hạn
                                  ),

                                  const SizedBox(height: 2),
                                  Text(
                                    postResponse.companyName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines:
                                        1, // Giới hạn số dòng (ở đây là 1 dòng)
                                    overflow: TextOverflow
                                        .ellipsis, // Thêm dấu "..." khi chữ vượt quá giới hạn
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${postResponse.location}  -  ${postResponse.salary}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 116, 33, 33),
                                    ),
                                  ),
                                  // Text(
                                  //   postResponse.salary,
                                  //   style: const TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 14,
                                  //     color: Color.fromARGB(255, 116, 33, 33),
                                  //   ),
                                  // ),
                                  Text(
                                    postResponse.experience,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 23, 69, 124),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Biểu tượng ở góc trên bên phải
                      Positioned(
                        top: 0, // Đặt biểu tượng ở góc trên
                        right: 0, // Đặt biểu tượng ở bên phải
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            bool isSaved = false;
                            return IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                              ),
                              onPressed: () =>
                                  _saveJob(context, isSaved, (bool value) {
                                setState(() {
                                  isSaved = value;
                                });
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 5), // Khoảng cách giữa nội dung và deadline
                  const Divider(
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled_rounded,
                          size: 16), // Icon với kích thước nhỏ hơn
                      const SizedBox(width: 4), // Khoảng cách giữa icon và text
                      Text(
                        postResponse.getDaysRemaining(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

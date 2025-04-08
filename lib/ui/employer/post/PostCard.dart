import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/ui/employer/post/EditPostPage.dart';
import 'package:dacn2/data/services/post_service.dart';
import 'PostDetail.dart';

// Job Card Widget
class PostCard extends StatelessWidget {
  final PostResponse postResponse;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  PostCard(
      {required this.postResponse,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    padding: const EdgeInsets.only(
                        top: 0, right: 20), // Thêm padding nếu cần
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
                                postResponse.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines:
                                    2, // Giới hạn số dòng (ở đây là 1 dòng)
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                postResponse.companyName,
                                style: const TextStyle(
                                  fontSize: 13,
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
                                  fontSize: 14,
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
                    child: PopupMenuButton<String>(
                      color: Colors.white,
                      icon: Icon(Icons.more_vert),
                      onSelected: (String result) {
                        switch (result) {
                          case 'Sửa':
                            onEdit();
                            break;
                          case 'Xóa':
                            // Hiển thị hộp thoại xác nhận
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Xác nhận'),
                                  content: Text(
                                      'Bạn có chắc muốn xóa bài viết này không?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Không'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Đóng hộp thoại nếu chọn "Không"
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Có'),
                                      onPressed: () {
                                        PostService(baseUrl: Util.baseUrl)
                                            .deletePost(postResponse.postId);
                                        onDelete();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            break;
                          case 'xem':
                            // Điều hướng đến trang review
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetail(postResponse: postResponse)),
                            );
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Sửa',
                          child: Text('Sửa'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Xóa',
                          child: Text('Xóa'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'xem',
                          child: Text('xem'),
                        ),
                      ],
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
                      fontSize: 13,
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
    );
  }
}

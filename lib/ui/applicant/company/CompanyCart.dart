import 'package:flutter/material.dart';
import 'package:dacn2/data/models/company.dart';
import 'CompanyDetail.dart';

// Job Card Widget
class CompanyCart extends StatelessWidget {
  final Company company;
  CompanyCart({required this.company}); // Constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyInfoPage(company: company)),
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
                      padding: const EdgeInsets.only(
                          top: 10, right: 10), // Thêm padding nếu cần
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
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: company.companyLogo.isNotEmpty
                                    ? NetworkImage(company.logoUrl)
                                    : const AssetImage(
                                            'images/default_profile.png')
                                        as ImageProvider,
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
                                  company.companyName,
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
                                  company.companyCategory,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Biểu tượng ở góc trên bên phải
                    const Positioned(
                      top: 0, // Đặt biểu tượng ở góc trên
                      right: 0, // Đặt biểu tượng ở bên phải
                      child: Icon(Icons.bookmark_outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

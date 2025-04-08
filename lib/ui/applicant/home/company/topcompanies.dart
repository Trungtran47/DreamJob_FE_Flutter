import 'package:dacn2/data/models/company.dart';
import 'package:flutter/material.dart';

class TopCompany extends StatelessWidget {
  final Company company;
  TopCompany({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 149, 223, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Material(
              elevation: 4.0, // Độ nổi của hiệu ứng
              shape: const CircleBorder(), // Đảm bảo hình tròn cho hiệu ứng

              child: InkWell(
                borderRadius: BorderRadius.circular(
                    500), // Tương tự bán kính của hình tròn
                onTap: () {
                  // Xử lý sự kiện nhấn (nếu cần)
                  print('Image tapped');
                },
                child: ClipOval(
                  child: Image.asset(
                    company.logoUrl,
                    height: 100,
                    width: 100, // Hình ảnh có chiều cao và chiều rộng bằng nhau
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(
              company.companyName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2, // Giới hạn số dòng (ở đây là 1 dòng)
              overflow: TextOverflow
                  .ellipsis, // Thêm dấu "..." khi chữ vượt quá giới hạn
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.center,
            child: Text(
              company.companyCategory,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

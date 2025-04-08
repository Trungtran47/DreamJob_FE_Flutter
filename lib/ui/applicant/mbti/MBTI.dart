import 'package:flutter/material.dart';
import 'package:dacn2/ui/applicant/nav/Bottomnav.dart';
import 'MBTIDetail.dart';
import 'TestMBTI.dart';

class MbtiPage extends StatefulWidget {
  @override
  _MbtiPageState createState() => _MbtiPageState();
}

class _MbtiPageState extends State<MbtiPage> {
  // Hàm để tạo một thẻ với viền riêng
  Widget buildItem(String title, String description, Color borderColor,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor, // Màu sắc của đường viền
          width: 1.5, // Độ dày của đường viền
        ),
      ),
      child: Row(
        children: [
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: onTap ??
                  () {
                    print('Image tapped');
                  },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'images/Logo_MBTI.png',
                  height: 70,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Dòng tiêu đề với viền
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Màu viền
                    width: 2.0, // Độ dày viền
                  ),
                  borderRadius: BorderRadius.circular(20), // Bo góc viền
                ),
                child: const Text(
                  "Khám phá tính cách MBTI",
                  style: TextStyle(
                    fontSize: 24, // Kích thước chữ
                    fontWeight: FontWeight.bold, // Đậm
                    color: Colors.black, // Màu chữ
                  ),
                  textAlign: TextAlign.center, // Căn giữa
                ),
              ),
              SizedBox(height: 20), // Khoảng cách giữa tiêu đề và các mục
              buildItem(
                "Giới thiệu về MBTI",
                "Trắc nghiệm tính cách MBTI (Myers-Briggs Type Indicator) là một phương pháp sử dụng hàng loạt các câu hỏi trắc nghiệm để phân tích ...",
                Colors.blue, // Màu viền của thẻ đầu tiên
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MBTIIntroductionPage()),
                  );
                },
              ),
              buildItem(
                "Khám phá tính cách MBTI của bản thân",
                "Thử trắc nghiệm MBTI để khám phá tính cách của bản thân và tìm hiểu về những nghề nghiệp phù hợp với tính cách của mình.",
                Colors.green, // Màu viền của thẻ thứ hai
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestMBTIPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

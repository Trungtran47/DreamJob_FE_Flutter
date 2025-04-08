import 'package:flutter/material.dart';

class MBTIIntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Giới thiệu về MBTI"),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề chính
            const Text(
              "Giới thiệu về MBTI (Myers-Briggs Type Indicator)",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Phần nguồn gốc
            const Text(
              "- MBTI (Myers-Briggs Type Indicator) là một công cụ trắc nghiệm tâm lý được phát triển dựa trên lý thuyết về các loại tính cách của Carl Jung. Công cụ này giúp khám phá và hiểu sâu hơn về tính cách, cách suy nghĩ, cảm xúc và hành vi của con người. MBTI được sử dụng rộng rãi trên toàn thế giới trong việc phát triển bản thân, định hướng nghề nghiệp, cải thiện giao tiếp và xây dựng đội nhóm.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // Nguồn gốc
            const Text(
              "Nguồn gốc của MBTI",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "- MBTI được sáng lập bởi Isabel Briggs Myers và mẹ của bà, Katharine Cook Briggs, vào giữa thế kỷ 20. Dựa trên lý thuyết tâm lý học của Carl Jung, họ phát triển một hệ thống trắc nghiệm nhằm phân loại con người thành các kiểu tính cách khác nhau. Hệ thống này tập trung vào việc xác định cách mỗi người tiếp nhận thông tin, ra quyết định và tương tác với thế giới.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // Cấu trúc
            const Text(
              "Cấu trúc của MBTI",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "- MBTI chia tính cách con người thành 16 loại dựa trên sự kết hợp của 4 cặp khái niệm đối lập:",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            _buildListTile(
              title:
                  "Hướng ngoại (Extraversion - E) và Hướng nội (Introversion - I):",
              description:
                  "- Hướng ngoại: Những người thích giao tiếp, năng động và lấy năng lượng từ thế giới bên ngoài.\nHướng nội: Những người thường tập trung vào nội tâm, suy nghĩ sâu sắc và cần không gian riêng để nạp năng lượng.",
            ),
            _buildListTile(
              title: "Giác quan (Sensing - S) và Trực giác (Intuition - N):",
              description:
                  "- Giác quan: Tập trung vào chi tiết cụ thể, thực tế và những gì có thể cảm nhận trực tiếp.\nTrực giác: Thích khám phá ý nghĩa sâu xa, những khả năng tương lai và kết nối giữa các ý tưởng.",
            ),
            _buildListTile(
              title: "Lý trí (Thinking - T) và Cảm xúc (Feeling - F):",
              description:
                  "- Lý trí: Đưa ra quyết định dựa trên logic, sự phân tích và tính khách quan.\nCảm xúc: Dựa trên các giá trị cá nhân và cảm nhận của bản thân khi đưa ra quyết định.",
            ),
            _buildListTile(
              title: "Nguyên tắc (Judging - J) và Linh hoạt (Perceiving - P):",
              description:
                  "- Nguyên tắc: Thích lên kế hoạch, tổ chức và sống theo cách có trật tự.\nLinh hoạt: Linh động, thích ứng và để ngỏ các khả năng.",
            ),
            const SizedBox(height: 20),

            // Ứng dụng
            const Text(
              "Ứng dụng của MBTI",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            _buildListTile(
              title: "Phát triển bản thân:",
              description:
                  "- MBTI giúp bạn hiểu rõ hơn về thế mạnh, điểm yếu và phong cách làm việc của bản thân, từ đó cải thiện hiệu quả cá nhân.",
            ),
            _buildListTile(
              title: "Hướng nghiệp:",
              description:
                  "MBTI được sử dụng để định hướng nghề nghiệp phù hợp với từng loại tính cách, giúp bạn lựa chọn con đường sự nghiệp dễ dàng hơn.",
            ),
            _buildListTile(
              title: "Giao tiếp:",
              description:
                  "- Hiểu rõ tính cách của người khác giúp cải thiện khả năng giao tiếp và giảm xung đột trong công việc, gia đình và xã hội.",
            ),
            _buildListTile(
              title: "Xây dựng đội nhóm:",
              description:
                  "- Trong môi trường làm việc, MBTI hỗ trợ việc hiểu và tận dụng điểm mạnh của từng thành viên, từ đó nâng cao hiệu quả đội nhóm.",
            ),
            const SizedBox(height: 20),

            // Kết luận
            const Text(
              "Kết luận",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "- MBTI là một phương pháp mạnh mẽ để khám phá và phát triển bản thân, cũng như cải thiện các mối quan hệ cá nhân và công việc. Với 16 loại tính cách đa dạng, MBTI không chỉ giúp bạn hiểu rõ hơn về bản thân mà còn về cách bạn tương tác với thế giới xung quanh. Hãy thử nghiệm và khám phá loại tính cách của mình ngay hôm nay để tận dụng tối đa tiềm năng của bạn!",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị mỗi mục nhỏ
  Widget _buildListTile({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

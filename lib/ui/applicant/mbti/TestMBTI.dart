import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'MbtiHelper.dart';
import 'package:flutter/material.dart';

class TestMBTIPage extends StatefulWidget {
  @override
  _TestMBTIPageState createState() => _TestMBTIPageState();
}

class _TestMBTIPageState extends State<TestMBTIPage> {
  final GenerativeModel _model;
  bool isLoading = false; // Theo dõi trạng thái tải
  _TestMBTIPageState()
      : _model = GenerativeModel(
          model: 'models/gemini-1.5-flash',
          apiKey: dotenv.env['GOOGLE_API_KEY']!,
        );

  // Lưu trữ câu hỏi và các câu trả lời của người dùng
  List<Question> questions = [
    Question(
      question: 'Tại một buổi tiệc, bạn sẽ:',
      options: [
        'A. Giao tiếp với nhiều người, kể cả người lạ',
        'B. Chỉ giao tiếp với với một số ít người mà bạn đã quen'
      ],
    ),
    Question(
      question: 'Bạn thấy mình là người nghiêng về kiểu nào nhiều hơn? ',
      options: ['A. Thực tế', ' B. Sáng tạo'],
    ),
    Question(
      question: 'Bạn nghĩ tình huống nào tồi tệ hơn? ',
      options: [
        ' A. Đầu óc của bạn cứ “bay bổng trên mây',
        ' B. Cuộc sống của bạn thật nhàm chán và không bao giờ thay đổi'
      ],
    ),
    Question(
      question: 'Bạn sẽ bị ấn tượng hơn với',
      options: [' A. Các nguyên tắc', ' B. Những cảm xúc'],
    ),
    Question(
      question: 'Khi quyết định việc gì đó, bạn thường hay dựa vào: ',
      options: ['A. Sự thuyết phục', ' B. Sự đồng cảm'],
    ),
    Question(
      question: 'Bạn thích làm việc theo kiểu nào nhiều hơn?',
      options: ['A. Theo đúng thời hạn', ' B. Tùy hứng'],
    ),
    Question(
      question: 'Bạn có khuynh hướng đưa ra các lựa chọn',
      options: [' A. Rất cẩn thận', ' B. Phần nào theo cảm nhận'],
    ),
    Question(
      question: 'Tại các bữa tiệc, bạn thường:',
      options: [
        ' A. Ở lại tới cùng và cảm thấy càng lúc càng hào hứng',
        ' B. Ra về sớm vì cảm thấy mệt mỏi dần'
      ],
    ),
    Question(
      question: 'Kiểu người nào sẽ thu hút bạn hơn?',
      options: [
        ' A. Người thực tế và có lý lẽ',
        'B. Người giàu trí tưởng tượng'
      ],
    ),
    Question(
      question: 'Điều nào khiến bạn thấy thích thú hơn?',
      options: ['A. Những điều thực tế', 'B. Những ý tưởng khả thi'],
    ),
    Question(
      question:
          'Khi đánh giá hoặc phán xét người khác, bạn thường hay dựa vào điều gì?',
      options: [' A. Luật lệ và nguyên tắc', ' B. Hoàn cảnh'],
    ),
    Question(
      question:
          'Khi tiếp cận, tiếp xúc người khác, bạn nghiêng về hướng nào hơn?',
      options: [
        ' A. Tiếp cận theo hướng khách quan',
        'B. Tiếp cận theo hướng sử dụng trải nghiệm cá nhân'
      ],
    ),
    Question(
      question: 'Phong cách của bạn nghiêng về hướng nào hơn?',
      options: [' A. Đúng giờ, nghiêm túc', ' B. Nhàn nhã, thoải mái'],
    ),
    Question(
      question: 'Bạn cảm thấy không thoải mái khi có những việc:',
      options: [' A. Chưa hoàn thiện', ' B. Đã quá hoàn thiện'],
    ),
    Question(
      question: 'Trong các mối quan hệ xã hội, bạn thường',
      options: [
        'A. Luôn nắm bắt kịp thời thông tin về các vấn đề của mọi người',
        ' B. Thường biết thông tin sau những người khác'
      ],
    ),

    /// 15 câu  test
  ];

  // Biến để lưu trữ câu hỏi hiện tại và câu trả lời của người dùng
  int currentQuestionIndex = 0;
  String userAnswer = '';
  Map<String, int> scoreMap = {
    'E': 0,
    'I': 0,
    'S': 0,
    'N': 0,
    'T': 0,
    'F': 0,
    'J': 0,
    'P': 0
  };

  // Gọi API để trả lời câu hỏi MBTI và lưu điểm cho các loại tính cách
  Future<String> callGeminiModel(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Hàm để xử lý câu hỏi MBTI và tính điểm cho loại tính cách
  Future<void> handleMbtiTest(String question, String answer) async {
    String prompt = '''
    Người dùng đang thực hiện bài kiểm tra MBTI. Câu hỏi: "$question"
    Người dùng trả lời: "$answer"
    Hãy trả lời về loại tính cách (E/I, S/N, T/F, J/P).
    ''';
    String response = await callGeminiModel(prompt);
    _updateScore(response);
  }

  // Cập nhật điểm số cho các loại tính cách dựa trên phản hồi
  void _updateScore(String response) {
    if (response.contains('E')) {
      scoreMap['E'] = scoreMap['E']! + 1;
    } else if (response.contains('I')) {
      scoreMap['I'] = scoreMap['I']! + 1;
    }
    if (response.contains('S')) {
      scoreMap['S'] = scoreMap['S']! + 1;
    } else if (response.contains('N')) {
      scoreMap['N'] = scoreMap['N']! + 1;
    }
    if (response.contains('T')) {
      scoreMap['T'] = scoreMap['T']! + 1;
    } else if (response.contains('F')) {
      scoreMap['F'] = scoreMap['F']! + 1;
    }
    if (response.contains('J')) {
      scoreMap['J'] = scoreMap['J']! + 1;
    } else if (response.contains('P')) {
      scoreMap['P'] = scoreMap['P']! + 1;
    }
  }

  String calculateMbtiResult() {
    String mbti = '';
    mbti += scoreMap['E']! > scoreMap['I']! ? 'E' : 'I';
    mbti += scoreMap['S']! > scoreMap['N']! ? 'S' : 'N';
    mbti += scoreMap['T']! > scoreMap['F']! ? 'T' : 'F';
    mbti += scoreMap['J']! > scoreMap['P']! ? 'J' : 'P';

    // Gọi hàm từ MbtiHelper
    String explanation = MbtiHelper.getExplanation(mbti);

    return 'Kết quả MBTI của bạn là: $mbti\n\n$explanation';
  }

  void nextQuestion(String answer) async {
    if (currentQuestionIndex < questions.length) {
      await handleMbtiTest(questions[currentQuestionIndex].question, answer);
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      String result = calculateMbtiResult();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Kết quả MBTI'),
            content: Text(result),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Kiểm tra MBTI'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: currentQuestionIndex < questions.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Câu hỏi
                  Text(
                    'Câu ${currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    questions[currentQuestionIndex].question,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),

                  // Đáp án nằm ngang
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildAnswerButton(
                            questions[currentQuestionIndex].options[0]),
                      ),
                      SizedBox(width: 10), // Khoảng cách giữa các nút
                      Expanded(
                        child: _buildAnswerButton(
                            questions[currentQuestionIndex].options[1]),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Thêm khoảng cách hai bên
                  child: Text(
                    calculateMbtiResult(),
                    style: TextStyle(
                      fontSize: 20, // Kích thước chữ nhỏ hơn một chút
                      height: 1.5, // Khoảng cách dòng
                      color: Colors.black87, // Màu chữ dễ đọc
                    ),
                    textAlign: TextAlign.justify, // Căn đều nội dung
                  ),
                ),
              ),
      ),
    );
  }

  // Hàm tạo nút đáp án với nhãn A/B
  Widget _buildAnswerButton(String answer) {
    return Column(
      children: [
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            nextQuestion(answer);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            answer,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class Question {
  final String question;
  final List<String> options;

  Question({required this.question, required this.options});
}

import 'package:dacn2/ui/login/Login.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": "images/Onboarding1.png",
      "title": "Việc làm xứng tầm",
      "description": "Thăng tiến nhanh, công việc hấp dẫn, thu nhập xứng tầm",
    },
    {
      "image": "images/Onboarding2.png",
      "title": "Cơ hội nghề nghiệp",
      "description": "Kết nối ngay với những nhà tuyển dụng hàng đầu.",
    },
    {
      "image": "images/Onboarding3.png",
      "title": "Nâng cao sự nghiệp",
      "description":
          "Vững chắc với những công việc lý tưởng, thu nhập bền vững.",
    },
  ];

  void _nextPage() {
    if (currentPage < onboardingData.length - 1) {
      currentPage++;
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Nếu đã ở trang cuối cùng, chuyển đến trang Login
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Thay thế với tên route phù hợp
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () {
                          // Chuyển đến trang Login khi bấm vào "Bỏ qua"
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "Bỏ qua",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) => OnboardingContent(
                        image: onboardingData[index]["image"]!,
                        title: onboardingData[index]["title"]!,
                        description: onboardingData[index]["description"]!,
                      ),
                    ),
                  ),
                ],
              ),
              // Move the dots above the button
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Button is now below the AnimatedContainer
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: ElevatedButton(
              //     onPressed: _nextPage, // Gọi hàm _nextPage() khi nhấn nút
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.all(16),
              //       backgroundColor: Colors.blueAccent,
              //       shape: CircleBorder(),
              //       elevation: 5,
              //     ),
              //     child: Icon(
              //       Icons.arrow_forward,
              //       color: Colors.white,
              //       size: 24,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.white : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}

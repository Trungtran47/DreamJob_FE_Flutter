import 'package:dacn2/data/util/EnterIpScreen.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/admin/company/admin_company.dart';
import 'package:dacn2/ui/admin/admin_user.dart';
import 'package:dacn2/ui/admin/blog/admi_blog.dart';
import 'package:dacn2/ui/admin/admin_home.dart';
import 'package:dacn2/ui/applicant/home/HomeScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import for dotenv
import 'package:dacn2/ui/login/Register.dart';
import 'package:dacn2/ui/onboar/Onboarding.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/ui/login/Login.dart'; // Import màn hình Login
import 'package:dacn2/ui/applicant/mbti/MBTI.dart';
import 'package:dacn2/ui/applicant/job/Jobpage.dart';
import 'package:dacn2/ui/applicant/company/CompanyPage.dart';
import 'package:dacn2/ui/applicant/blog/BlogPage.dart';
import 'package:dacn2/ui/login/ApplicantPage.dart';
import 'package:dacn2/ui/login/EmployerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/ui/employer/home/EmployerHomeScreen.dart';
import 'package:dacn2/ui/employer/profile/ProfileEmployer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? serverIp = prefs.getString('server_ip');
  String initialRoute;

  if (serverIp == null || serverIp.isEmpty) {
    initialRoute = '/enterIp';
  } else {
    Util.baseUrl = 'http://$serverIp:8080/DreamJob';
    Util.Ip = 'http://$serverIp';
    int? userId = prefs.getInt('userId');
    final roles = prefs.getInt('roles');

    if (userId == null || roles == null) {
      initialRoute = '/login';
    } else if (roles == 1) {
      initialRoute = '/homescreen';
    } else if (roles == 2) {
      initialRoute = '/employerhome';
    } else if (roles == 3) {
      initialRoute = '/adminHome';
    } else {
      initialRoute = '/login';
    }
  }

  runApp(MyApp(initialRoute: initialRoute, userId: prefs.getInt('userId')));
}

Future<void> clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final int? userId;

  MyApp({required this.initialRoute, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng Dụng Của Tôi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Cấu hình routes
      initialRoute: initialRoute,
      routes: {
        '/enterIp': (context) => EnterIpScreen(), // Màn nhập IP
        '/': (context) => OnboardingScreen(), // Màn hình Onboarding
        '/login': (context) => LoginScreen(), // Màn hình Login
        '/register': (context) => RegisterScreen(),
        '/homescreen': (context) => HomeScreen(),
        '/jobs': (context) => JobPage(),
        '/companies': (context) => CompanyPage(),
        '/blog': (context) => BlogPage(),
        '/tools': (context) => MbtiPage(),
        '/mbti': (context) => MbtiPage(),
        '/employerhome': (context) => EmployerHomeScreen(),
        '/adminHome': (context) => AdminHome(), // Trang CV
        '/adminBlog': (context) => AdminBlogPage(), // Trang CV
        '/adminUser': (context) => AdminUserPage(), // Trang CV
        '/adminCompany': (context) => AdminCompanyPage(), // Trang CV
      },
    );
  }
}

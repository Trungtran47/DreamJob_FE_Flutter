import 'package:flutter/material.dart';
import 'package:dacn2/ui/login/Register.dart';
import 'package:dacn2/ui/applicant/home/Home.dart';
import 'package:dacn2/ui/applicant/home/HomeScreen.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Thêm GlobalKey
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            // Sử dụng Form
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(
                  'images/Logo.png',
                  height: 150,
                ),
                SizedBox(height: 10),
                Text(
                  "Chào mừng bạn đến với DreamJob",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                // TextField cho email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    } else if (!value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null; // Hợp lệ
                  },
                ),
                SizedBox(height: 20),
                // TextField cho mật khẩu
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    } else if (value.length < 5) {
                      return 'Mật khẩu phải có ít nhất 5 ký tự';
                    }
                    return null; // Hợp lệ
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/enterIp');
                    },
                    child: Text("Quên mật khẩu?",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Gọi validate khi nhấn nút Đăng nhập
                    if (_formKey.currentState!.validate()) {
                      _login(); // Nếu form hợp lệ, tiến hành đăng nhập
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 130),
                  ),
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Bạn chưa có tài khoản?",
                        style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text("Đăng ký ngay",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text("Hoặc", style: TextStyle(color: Colors.grey)),
                // Nút đăng nhập Google
                ElevatedButton.icon(
                  onPressed: () {
                    // Xử lý sự kiện đăng nhập Google
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey), // Viền xám
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  icon: Icon(Icons.g_mobiledata, color: Colors.red),
                  label: Text("Continue with Google",
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 10),
                // Nút đăng nhập Facebook
                ElevatedButton.icon(
                  onPressed: () {
                    // Xử lý sự kiện đăng nhập Facebook
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey), // Viền xám
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  icon: Icon(Icons.facebook, color: Colors.blue),
                  label: Text("Continue with Facebook",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await userService.loginUser(
        User(
          userId: 0, // Giá trị mặc định, sẽ được cập nhật từ server
          username: '', // Giá trị mặc định, sẽ được cập nhật từ server
          email: emailController.text,
          password: passwordController.text,
          fullName: '', // Giá trị mặc định, sẽ được cập nhật từ server
          roles: 0, // Giá trị mặc định, sẽ được cập nhật từ server
          phone: 0, // Giá trị mặc định, sẽ được cập nhật từ server
          avatar: '', // Giá trị mặc định, sẽ được cập nhật từ server
          // post: [], // Giá trị mặc định, sẽ được cập nhật từ server
          cv: '', // Giá trị mặc định, sẽ được cập nhật từ server
          location: '', // Giá trị mặc định, sẽ được cập nhật từ server
          experience: '', // Giá trị mặc định, sẽ được cập nhật từ server
          desiredJob: '', // Giá trị mặc định, sẽ được cập nhật từ server
          // company: null, // Giá trị mặc định, sẽ được cập nhật từ server
        ),
      );
      // Lưu thông tin session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.userId);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      await prefs.setInt('roles', user.roles); // Lưu thông tin roles

      // Xử lý sau khi đăng nhập thành công
      if (user.roles == 1) {
        Navigator.pushReplacementNamed(context, '/homescreen');
      } else if (user.roles == 2) {
        Navigator.pushReplacementNamed(context, '/employerhome');
      } else if (user.roles == 3) {
        Navigator.pushReplacementNamed(context, '/adminHome');
      }
    } catch (error) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

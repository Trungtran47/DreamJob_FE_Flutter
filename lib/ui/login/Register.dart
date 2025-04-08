import 'package:dacn2/ui/login/Login.dart';
import 'package:flutter/material.dart';
import 'ApplicantPage.dart';
import 'EmployerPage.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  int roles = 1; // Mặc định là applicant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Đăng ký'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // Màu nhạt ở trên
                const Color.fromARGB(
                    255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
                Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Logo
                  Image.asset(
                    'images/Logo.png', // Đường dẫn logo của bạn
                    height: 150,
                  ),
                  // SizedBox(height: 10),
                  Text(
                    "Chào mừng bạn đến với DreamJob",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  // Tiêu đề Đăng ký
                  Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  // TextFormField cho họ và tên
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      labelText: 'Họ và Tên',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  // TextFormField cho email
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
                  // TextFormField cho tên người dùng
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Tên người dùng',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // TextFormField cho mật khẩu
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      } else if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null; // Hợp lệ
                    },
                  ),
                  SizedBox(height: 20),
                  // TextFormField cho nhập lại mật khẩu
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Nhập lại mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập lại mật khẩu';
                      } else if (value != passwordController.text) {
                        return 'Mật khẩu không khớp';
                      }
                      return null;
                    },
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.zero, // Loại bỏ padding mặc định
                          title: const Text('Người tìm việc'),
                          leading: Radio<int>(
                            value: 1,
                            groupValue: roles,
                            onChanged: (int? value) {
                              setState(() {
                                roles = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.zero, // Loại bỏ padding mặc định
                          title: const Text('Nhà tuyển dụng'),
                          leading: Radio<int>(
                            value: 2,
                            groupValue: roles,
                            onChanged: (int? value) {
                              setState(() {
                                roles = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Nút Đăng ký
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 130),
                    ),
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // Đăng nhập
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Bạn đã có tài khoản?",
                          style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text("Đăng nhập ngay",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRoleSelectionDialog(int userId) {
    if (roles == 1) {
      Navigator.pushNamed(context, '/login');
    } else if (roles == 2) {
      Navigator.pushNamed(context, '/login');
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Xử lý đăng ký tài khoản
      final user = User(
        userId: 0,
        username: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        fullName: fullNameController.text,
        phone: 0, // Thêm giá trị phone nếu cần
        roles: roles, // Sử dụng giá trị role từ radio button
        avatar: "0", // Thêm giá trị avatar nếu cần
        // post: [], // Thêm giá trị post nếu cần
        cv: "", // Thêm giá trị cv nếu cần
        location: "", // Thêm giá trị location nếu cần
        experience: "", // Thêm giá trị experience nếu cần
        desiredJob: "", // Thêm giá trị desired_job nếu cần
        // company: null, // Thêm giá trị company nếu cần
      );
      try {
        final registeredUser = await userService.registerUser(user);
        _showRoleSelectionDialog(registeredUser.userId);
      } catch (error) {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: $error')),
        );
      }
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/services/company_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:image_picker/image_picker.dart';
import 'editUser.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/ui/employer/company/CompanyProfile.dart'; // Import màn hình CompanyProfile
import 'package:dacn2/ui/employer/company/CompanyProfileUpadate.dart';
import 'package:dacn2/data/services/company_service.dart';

class EmployerProfilepage extends StatefulWidget {
  EmployerProfilepage({Key? key}) : super(key: key);
  @override
  EmployerProfilePageState createState() => EmployerProfilePageState();
}

class EmployerProfilePageState extends State<EmployerProfilepage> {
  void reloadPage() {
    setState(() {
      _loadUserAndCompany();
    });
  }

  late Future<User> futureUser;
  late Future<Company?> futureCompany;
  final UserService userService = UserService(baseUrl: Util.baseUrl);
  final CompanyService companyService = CompanyService(baseUrl: Util.baseUrl);
  late int userId;
  File? _image;

  @override
  void initState() {
    super.initState();
    futureUser = Future.error('Loading...');
    futureCompany = Future.error('Loading...');
    _loadUserAndCompany();
    // _getCompanuByUserId();
  }

  Future<void> _loadUserAndCompany() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        futureCompany = companyService.getCompanyByUserId(userId);
        futureUser = userService.getUserById(userId);
      });
    } else {
      setState(() {
        futureCompany = Future.error('User ID not found');
        futureUser = Future.error('User ID not found');
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildInfoRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        SizedBox(width: 10),
        Text(
          info,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _CompanyProfile(Company? company) {
    if (company == null || company.companyId == null) {
      return Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyProfile(
                  userId: userId,
                  companyService: companyService,
                ),
              ),
            );

            if (result != null) {
              setState(() {
                futureCompany = companyService.getCompanyByUserId(userId);
              });
            }
          },
          child: Text('Thêm công ty'),
        ),
      );
    } else {
      return Card(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: company.companyLogo.isNotEmpty
                        ? NetworkImage(company.logoUrl)
                        : AssetImage('images/default_profile.png')
                            as ImageProvider,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                company.companyName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              Divider(height: 20, thickness: 1),
              // _infoRow(Icons.business, 'Id', company.companyId.toString()),
              // _infoRow(Icons.business, 'Tên công ty', company.companyName),
              _infoRow(Icons.category, 'Loại công ty', company.companyCategory),
              _infoRow(Icons.web, 'Website', company.companyWebsite),
              _infoRow(Icons.location_on, 'Địa chỉ', company.companyLocation),
              _infoRow(Icons.people, 'Số nhân viên', company.companySize),
              _infoRow(Icons.description, 'Mô tả', company.companyIntroduce),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyProfileUpdate(
                        companyId: company.companyId!,
                        userId: userId,
                        companyService: companyService,
                        company: company, // Truyền dữ liệu công ty để cập nhật
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      futureCompany = companyService.getCompanyByUserId(userId);
                      // _loadUserAndCompany();
                    });
                  }
                },
                icon: Icon(Icons.edit),
                label: Text('Chỉnh sửa công ty'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 0, 2, 4), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header Section
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF039BE5),
                    Color(0xFFB3E5FC), // Xanh nhạt nhẹ ở giữa
                    Colors.white, // Xanh đậm hơn ở dưới
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : (user.avatar != "0"
                                          ? NetworkImage(user.avatar)
                                          : AssetImage(
                                              'images/default_profile.png'))
                                      as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.camera_alt,
                                      size: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5),
                              Text(
                                user.email,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 5),
                              _buildInfoRow(
                                  Icons.phone,
                                  user.phone
                                      .toString()), // Số điện thoại của bạn
                              // _buildInfoRow(Icons.business, "Position: ${user.fullName}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserInfo(
                                currentUserId: user.userId,
                                currentName: user.username,
                                currentPhone: user.phone,
                                currentAvatar: user.avatar,
                                currentEmail: user.email,
                                currentRoles: user.roles,
                                // currentPost: user.post,
                                currentPassword: user.password,
                                currentFullName: user.fullName,
                                currentCv: user.cv,
                                currentLocation: user.location,
                                currentExperience: user.experience,
                                currentDesiredJob: user.desiredJob,
                                // currentCompany:
                                //     user.company, // Truyền dữ liệu công ty
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _loadUserAndCompany();
                              futureUser = Future.value(user.copyWith(
                                userId: result['userId'],
                                fullName: result['FullName'],
                                phone: result['phone'],
                                avatar: result['image'] != null
                                    ? result['image'].path
                                    : user.avatar,
                                username: result['username'],
                                password: result['password'],
                                email: result['email'],
                                roles: result['roles'],
                                // post: result['post'],
                                cv: result['cv'],
                                location: result['location'],
                                experience: result['experience'],
                                desiredJob: result['desired_job'],
                              ));

                              if (result['image'] != null) {
                                _image = result['image'];
                              }
                            });
                          }
                        },
                        child: Icon(Icons.edit, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Company Information Section
          // _CompanyProfile(user.company),
          // _buildProfile(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        Divider(),
        // Account Settings Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Cài đặt tài khoản',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: Icon(Icons.upgrade),
          title: Text('Nâng cấp tài khoản VIP'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Đổi mật khẩu'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Đăng Xuất'),
          onTap: () async {
            // Hiển thị hộp thoại xác nhận
            bool? confirmLogout = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Đăng Xuất'),
                    ),
                  ],
                );
              },
            );

            if (confirmLogout == true) {
              // Xóa thông tin session
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              // Điều hướng đến màn hình đăng nhập
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Xóa hoặc hủy tài khoản'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
        Divider(),
        // Support and Policies Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Chính sách và hỗ trợ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: Icon(Icons.policy),
          title: Text('Về DreamJob'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('Điều khoản dịch vụ'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
        ListTile(
          leading: Icon(Icons.support),
          title: Text('Trợ giúp'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text('Chính sách bảo mật'),
          onTap: () {
            // Xử lý khi nhấn vào mục này
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Trang cá nhân nhà tuyển dụng'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFB3E5FC), // Xanh nhạt nhẹ ở giữa
                  Color(0xFF039BE5), // Xanh đậm hơn ở dưới
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                FutureBuilder<User>(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('Không tìm thấy người dùng'));
                    } else {
                      final user = snapshot.data!;
                      return _buildUserProfile(user);
                    }
                  },
                ),
                FutureBuilder<Company?>(
                  future: futureCompany,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyProfile(
                                  userId: userId,
                                  companyService: companyService,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                futureCompany =
                                    companyService.getCompanyByUserId(userId);
                              });
                            }
                          },
                          child: Text('Thêm công ty'),
                        ),
                      );
                    } else {
                      final company = snapshot.data!;
                      return _CompanyProfile(company);
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildProfile(),
                ),
              ],
            ),
          ),
        ));
  }
}

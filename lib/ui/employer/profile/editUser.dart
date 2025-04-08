import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/data/models/post.dart'; // Add this line to import the Post model

class EditUserInfo extends StatefulWidget {
  final int currentUserId;
  final String currentName;
  final int currentPhone;
  final String currentAvatar;
  final String currentFullName;
  final int currentRoles;
  // final List<dynamic> currentPost;
  final String currentEmail;
  final String currentPassword;
  final String currentCv;
  final String currentLocation;
  final String currentExperience;
  final String currentDesiredJob;
  // final Company? currentCompany;

  EditUserInfo({
    required this.currentName,
    required this.currentUserId,
    required this.currentPhone,
    required this.currentAvatar,
    required this.currentFullName,
    required this.currentRoles,
    // required this.currentPost,
    required this.currentEmail,
    required this.currentPassword,
    required this.currentCv,
    required this.currentLocation,
    required this.currentExperience,
    required this.currentDesiredJob,
    // required this.currentCompany,
  });

  @override
  _EditUserInfoState createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _fullNameController;
  File? _image;
  final UserService userService = UserService(baseUrl: Util.baseUrl);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController =
        TextEditingController(text: widget.currentPhone.toString());
    _fullNameController = TextEditingController(text: widget.currentFullName);
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = User(
          userId: widget.currentUserId, // Thay thế bằng userId thực tế
          username: _nameController.text, // Thay thế bằng username thực tế
          password: widget.currentPassword, // Thay thế bằng password thực tế
          email: widget.currentEmail, // Thay thế bằng email thực tế
          fullName: _fullNameController.text,
          phone: int.parse(_phoneController.text),
          roles: widget.currentRoles, // Thay thế bằng roles thực tế
          // post: widget.currentPost
          //     .cast<Post>(), // Ensure Post is imported correctly
          avatar: widget.currentAvatar, // Thay thế bằng avatar thực tế
          cv: widget.currentCv, // Thay thế bằng cv thực tế
          location: widget.currentLocation, // Thay thế bằng location thực tế
          experience:
              widget.currentExperience, // Thay thế bằng experience thực tế
          desiredJob:
              widget.currentDesiredJob, // Thay thế bằng desired_job thực tế
          // company: null, // Thay thế bằng company thực tế
        );

        await userService.updateEmployer(widget.currentUserId, user, _image);
        Navigator.pop(context, {
          'success': true,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'image': _image,
          'fullName': _fullNameController.text,
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin thất bại: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin cá nhân'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (widget.currentAvatar != "0"
                                  ? NetworkImage(widget.currentAvatar)
                                  : AssetImage('images/default_profile.png'))
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
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên đầy đủ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ tên đầy đủ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateUserInfo,
                  child: Text('Lưu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

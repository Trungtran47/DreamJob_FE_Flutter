import 'package:dacn2/data/models/province.dart';
import 'package:dacn2/data/services/province_service.dart';
import 'package:dacn2/ui/widget/LocationDropdown.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateProfile extends StatefulWidget {
  final User user;
  UpdateProfile({required this.user});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _experienceController;
  late TextEditingController _desiredJobController;
  late TextEditingController _nameController;
  String? _selectedLocation; // Default location
  File? _image;
  final UserService userService = UserService(baseUrl: Util.baseUrl);

  late int user;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _phoneController =
        TextEditingController(text: widget.user.phone.toString());
    _emailController = TextEditingController(text: widget.user.email);
    _experienceController = TextEditingController(text: widget.user.experience);
    _desiredJobController = TextEditingController(text: widget.user.desiredJob);
    _selectedLocation =
        widget.user.location; // Set default to user's current location
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

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        userId: widget.user.userId,
        username: _nameController.text,
        password: widget.user.password,
        roles: widget.user.roles,
        avatar: widget.user.avatar,
        fullName: _fullNameController.text,
        phone: int.parse(_phoneController.text),
        email: _emailController.text,
        experience: _experienceController.text,
        desiredJob: _desiredJobController.text,
        location: _selectedLocation ?? '',
        cv: widget.user.cv,
      );
      try {
        await userService.updateApplicant(widget.user.userId, user, _image);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thông tin công ty đã được cập nhật')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra: $e')),
        );
        print('Có lỗi xảy ra: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cập nhật hồ sơ'),
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
                          : (widget.user.avatar != "0"
                                  ? NetworkImage(widget.user.avatar)
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
                _buildTextField(
                    _nameController, 'Tên', 'Vui lòng nhập họ và tên của bạn'),
                _buildTextField(_fullNameController, 'Họ và Tên',
                    'Vui lòng nhập họ và tên của bạn'),
                _buildTextField(_phoneController, 'Số điện thoại',
                    'Vui lòng nhập số điện thoại của bạn',
                    keyboardType: TextInputType.phone),
                // _buildTextField(
                //     _emailController, 'Email', 'Vui lòng nhập email của bạn',
                //     keyboardType: TextInputType.emailAddress),
                _buildTextField(_experienceController, 'Kinh nghiệm',
                    'Vui lòng nhập kinh nghiệm của bạn'),
                _buildTextField(_desiredJobController, 'Công việc mong muốn',
                    'Vui lòng nhập công việc mong muốn của bạn'),
                LocationDropdown(
                  selectedLocation: _selectedLocation,
                  onLocationChanged: (newLocation) {
                    setState(() {
                      _selectedLocation = newLocation;
                    });
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Lưu thông tin', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: const Color.fromARGB(255, 95, 170, 205),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded button
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String validationMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          labelStyle: TextStyle(color: Colors.blueAccent),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
      ),
    );
  }
}

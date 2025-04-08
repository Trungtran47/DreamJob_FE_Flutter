import 'dart:io';
import 'package:dacn2/ui/widget/LocationDropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/data/services/company_service.dart';
import 'package:dacn2/ui/employer/profile/ProfileEmployer.dart';
import 'package:dacn2/data/util/Util.dart'; // Import màn hình EmployerProfile
import 'package:dacn2/data/services/user_service.dart';

class CompanyProfile extends StatefulWidget {
  final int userId;
  final CompanyService companyService;
  final Company? company;

  CompanyProfile(
      {required this.userId, required this.companyService, this.company});

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;
  String? _locationController;
  late TextEditingController _categoryController;
  late TextEditingController _sizeController;
  final UserService userService = UserService(baseUrl: Util.baseUrl);

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.company?.companyName ?? '');
    _descriptionController =
        TextEditingController(text: widget.company?.companyIntroduce ?? '');
    _websiteController =
        TextEditingController(text: widget.company?.companyWebsite ?? '');
    _locationController = widget.company?.companyLocation ?? '';
    _categoryController =
        TextEditingController(text: widget.company?.companyCategory ?? '');
    _sizeController =
        TextEditingController(text: widget.company?.companySize ?? '');
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

  Future<void> _saveCompany() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn ảnh công ty')),
        );
        return; // Dừng lại, không tiếp tục lưu thông tin
      }
      try {
        final company = Company(
          companyId: widget.company?.companyId ?? 0,
          companyName: _nameController.text,
          companyIntroduce: _descriptionController.text,
          companyWebsite: _websiteController.text,
          companyLocation: _locationController ?? '',
          companyCategory: _categoryController.text,
          companySize: _sizeController.text,
          companyLogo:
              _image != null ? _image!.path : widget.company?.companyLogo ?? '',
        );
        await widget.companyService.saveCompany(widget.userId, company, _image);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thông tin công ty đã được lưu')),
        );
        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu thông tin công ty: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _locationController;
    _categoryController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Thông tin công ty'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (widget.company?.companyLogo != null &&
                                    widget.company!.companyLogo.isNotEmpty
                                ? NetworkImage(widget.company!.companyLogo)
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
                  labelText: 'Tên công ty',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên công ty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Mô tả công ty',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả công ty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Loại hình công ty',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập loai hinh cong ty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập website';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              LocationDropdown(
                selectedLocation: _locationController,
                onLocationChanged: (newLocation) {
                  setState(() {
                    _locationController = newLocation;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Số lượng nhân viên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số lượng nhân viên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCompany,
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

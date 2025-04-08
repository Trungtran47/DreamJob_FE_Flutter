// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:dacn2/data/models/company.dart';
// import 'package:dacn2/data/services/user_service.dart';
// import 'package:dacn2/data/util/Util.dart';

// class EmployerDetailsPage extends StatefulWidget {
//   final int userId;

//   EmployerDetailsPage({required this.userId});

//   @override
//   _EmployerDetailsPageState createState() => _EmployerDetailsPageState();
// }

// class _EmployerDetailsPageState extends State<EmployerDetailsPage> {
//   final _formKey = GlobalKey<FormState>();
//   String companyName = '';
//   String companyDescription = '';
//   String companyWebsite = '';
//   String companyLocation = '';
//   String numberEmployees = '';
//   String imageLogo = '';
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;
//   final UserService userService = UserService(baseUrl: Util.baseUrl);

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile;
//       imageLogo = pickedFile?.path ?? '';
//     });
//   }

//   Future<void> _registerEmployer() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       if (_imageFile != null) {
//         final employer = Company(
//           userId: widget.userId,
//           companyName: companyName,
//           companyDescription: companyDescription,
//           companyWebsite: companyWebsite,
//           companyLocation: companyLocation,
//           numberEmployees: numberEmployees,
//           imageLogo: imageLogo,
//         );
//         try {
//           final registeredEmployer = await userService.registerEmployer(
//               employer, File(_imageFile!.path));
//           // Xử lý sau khi đăng ký thành công
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Đăng ký thành công')),
//           );
//         } catch (error) {
//           // Xử lý lỗi
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Đăng ký thất bại: $error')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Vui lòng chọn ảnh logo')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thông tin chi tiết'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white, // Màu nhạt ở trên
//                 const Color.fromARGB(
//                     255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
//                 Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
//               ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   // Các trường nhập liệu cho thông tin công ty
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Tên công ty',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onSaved: (value) {
//                       companyName = value ?? '';
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Mô tả công ty',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onSaved: (value) {
//                       companyDescription = value ?? '';
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Website công ty',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onSaved: (value) {
//                       companyWebsite = value ?? '';
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Địa chỉ công ty',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onSaved: (value) {
//                       companyLocation = value ?? '';
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Số lượng nhân viên',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onSaved: (value) {
//                       numberEmployees = value ?? '';
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   // Nút chọn ảnh logo
//                   ElevatedButton(
//                     onPressed: _pickImage,
//                     child: Text('Chọn ảnh logo'),
//                   ),
//                   SizedBox(height: 20),
//                   // Hiển thị ảnh logo đã chọn
//                   _imageFile != null
//                       ? Image.file(File(_imageFile!.path))
//                       : Text('Chưa chọn ảnh logo'),
//                   SizedBox(height: 20),
//                   // Nút đăng ký
//                   ElevatedButton(
//                     onPressed: _registerEmployer,
//                     child: Text('Đăng ký'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

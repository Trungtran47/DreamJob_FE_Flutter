import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dacn2/data/services/blog_service.dart';
import 'package:dacn2/data/models/blog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();
  XFile? _image;
  final BlogService blogService = BlogService(baseUrl: Util.baseUrl);

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> createBlog() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final Blog blog = Blog(
      user: userId,
      title: _titleController.text,
      content: _contentController.text,
      time: DateTime.now().toString(),
      author: _authorController.text,
    );
    try {
      await blogService.createBlog(
          blog, _image != null ? File(_image!.path) : null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tạo blog thành công'),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lôi khi tạo blog'),
        ),
      );
      print('Error occurred while creating blog: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Text('Create Blog'),
      ),
      body: SingleChildScrollView(
        // Add this to make the content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tải hình ảnh lên',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          'Nhấn để chọn một hình ảnh',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(_image!.path),
                        height: 150.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Người viết',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                createBlog();
              },
              child: Text('Create Blog'),
            ),
          ],
        ),
      ),
    );
  }
}

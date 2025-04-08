import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Sử dụng flutter_pdfview
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'package:dacn2/data/models/response/UserCv.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';
import 'WebView.dart';

class CvPage extends StatefulWidget {
  CvPage({Key? key}) : super(key: key);
  @override
  CvPageState createState() => CvPageState();
}

class CvPageState extends State<CvPage> {
  void reloadPage() {
    setState(() {
      _loadUser();
    });
  }

  String? _fileName;
  String? _filePath;
  late int userId;
  final userService = UserService(baseUrl: Util.baseUrl);
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = Future.error('Loading ...'); // Set initial value to error
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdFromPrefs = prefs.getInt('userId');
    if (userIdFromPrefs != null) {
      setState(() {
        userId = userIdFromPrefs;
        futureUser = userService.getUserById(userId);
      });

      // Tải thông tin tệp CV
      var user = await futureUser;
      if (user.cv != null && user.cv.isNotEmpty) {
        setState(() {
          _fileName = user.cv;
          _filePath = '${Util.baseUrl}/uploads/Cv/${user.cv}';
          print('$_filePath');
        });
      }
    } else {
      setState(() {
        futureUser = Future.error('Không tìm thấy ID người dùng');
      });
    }
  }

  Future<void> _updateCv() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    if (_filePath != null) {
      File file = File(_filePath!);
      try {
        await userService.updateCv(userId, file);
        _loadUser();
        Fluttertoast.showToast(
          msg: "Tệp  $_fileName đã được lưu thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        print('Lỗi khi lưu tệp: $e');
        Fluttertoast.showToast(
          msg: "Không thể lưu tâp tin: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final filePath =
          result.files.single.path; // Lưu đường dẫn để xem trước file PDF

      if (filePath != null) {
        File file = File(filePath);
        // Kiểm tra kích thước file
        final fileSize = await file.length(); // Kích thước file tính bằng bytes

        // Giới hạn kích thước file tối đa là 2MB (2 * 1024 * 1024 bytes)
        if (fileSize <= 10 * 1024 * 1024) {
          setState(() {
            _fileName = result.files.single.name;
            _filePath = filePath; // Lưu đường dẫn
          });
          Fluttertoast.showToast(
            msg: "Tệp được tải lên thành công: $_fileName",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Kích thước tệp quá lớn. Vui lòng chọn tệp nhỏ hơn 10MB.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Đã hủy tải lên tệp",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _deleteFile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    try {
      await userService.deleteCv(userId);
      setState(() {
        _fileName = null;
        _filePath = null;
      });
      Fluttertoast.showToast(
        msg: "Đã xóa tệp thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Không thể xóa tệp: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  // void _deleteFile() {
  //   setState(() {
  //     _fileName = null;
  //     _filePath = null;
  //   });
  //   Fluttertoast.showToast(
  //     msg: "Đã xóa tệp thành công",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.red,
  //     textColor: Colors.white,
  //   );
  // }

// Define a common TextStyle for buttons
  TextStyle commonTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

// In your build method:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('CV của bạn'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                const Color.fromARGB(255, 149, 223, 255),
                Colors.lightBlueAccent.shade400,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _pickFile,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'images/Logo.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_fileName != null) ...[
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.description, color: Colors.blue),
                  title: Text(_fileName!),
                  subtitle: Text('Đã chọn tệp'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.preview, color: Colors.blue),
                          onPressed: () {
                            if (_filePath != null &&
                                _filePath!.endsWith('.pdf')) {
                              if (_filePath!.startsWith('http') ||
                                  _filePath!.startsWith('https')) {
                                // Mở ở chế độ PDFWebViewPage nếu đường dẫn là URL
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFWebViewPage(
                                      pdfUrl: _filePath!,
                                    ),
                                  ),
                                );
                              } else {
                                // Mở ở chế độ PDFPreviewPage nếu đường dẫn là của máy
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFPreviewPage(
                                      filePath: _filePath!,
                                      fileName: _fileName!,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Bản xem trước không có sẵn cho loại tệp này",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.orange,
                                textColor: Colors.white,
                              );
                            }
                          }),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: _deleteFile,
                      ),
                    ],
                  ),
                ),
              ),
            ] else
              const Center(
                child: Text(
                  'Không có tập tin nào được chọn',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            if (_fileName == null) ...[
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(Icons.file_upload),
                  label: Text('Chọn cv của bạn', style: commonTextStyle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 171, 197, 241),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                ),
              ),
            ],
            if (_fileName != null) ...[
              if (_filePath!.startsWith('http') ||
                  _filePath!.startsWith('https')) ...[
                // Hiển thị nút tải CV nếu CV đã được upload
                Center(
                    child: Text('Bạn đã lưu CV của mình',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 1, 62, 167),
                            fontSize: 16,
                            decorationStyle: TextDecorationStyle.solid))),
              ] else ...[
                const SizedBox(
                    height: 20), // Hiển thị nút lưu nếu tệp không phải là URL
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updateCv();
                    },
                    icon: Icon(Icons.save),
                    label: Text('Lưu file CV'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// Màn hình xem trước PDF
class PDFPreviewPage extends StatelessWidget {
  final String filePath;

  const PDFPreviewPage(
      {Key? key, required this.filePath, required this.fileName})
      : super(key: key);

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fileName'),
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
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageSnap: true,
        onError: (e) {
          print('Error: $e');
        },
      ),
    );
  }
}

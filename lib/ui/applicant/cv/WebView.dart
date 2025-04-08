import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFWebViewPage extends StatefulWidget {
  final String pdfUrl;

  PDFWebViewPage({required this.pdfUrl});

  @override
  _PDFWebViewPageState createState() => _PDFWebViewPageState();
}

class _PDFWebViewPageState extends State<PDFWebViewPage> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadFile(widget.pdfUrl);
  }

  Future<void> _downloadFile(String url) async {
    try {
      var dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      var filePath = '${dir.path}/temp.pdf';

      // Kiểm tra và xóa tệp cũ nếu tồn tại
      if (await File(filePath).exists()) {
        await File(filePath).delete();
      }

      print("Đường dẫn tệp: $filePath");
      await dio.download(url, filePath);
      setState(() {
        localFilePath = filePath;
      });
    } catch (e) {
      print('Lỗi khi tải tệp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xem PDF"),
        centerTitle: true,
      ),
      body: localFilePath != null
          ? Container(
              margin: EdgeInsets.all(8.0), // Thêm lề để làm đẹp
              child: PDFView(
                filePath: localFilePath,
                fitEachPage: true, // Làm cho PDF khớp với kích thước màn hình
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

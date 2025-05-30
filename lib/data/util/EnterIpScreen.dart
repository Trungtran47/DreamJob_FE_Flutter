import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart'; // Để truy cập class Util (hoặc bạn có thể tách riêng Util ra file riêng)

class EnterIpScreen extends StatefulWidget {
  @override
  _EnterIpScreenState createState() => _EnterIpScreenState();
}

class _EnterIpScreenState extends State<EnterIpScreen> {
  TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  Future<void> _loadSavedIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedIp = prefs.getString('server_ip');
    if (savedIp != null) {
      _ipController.text = savedIp;
    }
  }

  Future<void> _saveIpAndContinue() async {
    String ip = _ipController.text.trim();
    if (ip.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('server_ip', ip);
      Util.baseUrl = 'http://$ip:8080/DreamJob'; // Nối IP nhập với phần còn lại
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập IP Server')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'Chỉ nhập IP, ví dụ: 192.168.1.110',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIpAndContinue,
              child: Text('Tiếp tục'),
            ),
          ],
        ),
      ),
    );
  }
}

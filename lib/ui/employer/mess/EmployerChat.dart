import 'package:dacn2/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/services/message_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/data/models/request/message_send.dart';
import 'package:intl/intl.dart';
import 'package:dacn2/ui/applicant/cv/WebView.dart';

class ChatPage extends StatefulWidget {
  final int messageId;
  final String apllicantName;
  final String filePath;
  final User user;

  ChatPage({
    required this.messageId,
    required this.user,
    required this.apllicantName,
    required this.filePath,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  Future<List<Map<String, dynamic>>>? messages;
  final MessageService messageService = MessageService(baseUrl: Util.baseUrl);
  final _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Thêm ScrollController

  @override
  void initState() {
    super.initState();
    _loadMessageDetail();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); // Hủy ScrollController
    super.dispose();
  }

  // Hàm tải danh sách tin nhắn
  Future<void> _loadMessageDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getInt('userId'); // Lấy userId hiện tại
    if (currentUserId != null) {
      try {
        final messageDetails =
            await messageService.getMessageDetail(widget.messageId);
        setState(() {
          messages = Future.value(
            messageDetails.map((message) {
              return {
                'text': message.content,
                'time': message.sendingTime,
                'isSentByMe': message.userId == currentUserId,
              };
            }).toList(),
          );
        });
        _scrollToBottom(); // Cuộn xuống cuối
      } catch (e) {
        print('Error loading messages: $e');
      }
    } else {
      print('Applicant ID is null');
    }
  }

  // Hàm cuộn xuống cuối
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatDateTime(String dateTime) {
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    final DateTime now = DateTime.now();
    // So sánh ngày, tháng, năm giữa parsedDateTime và current time (now)
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final DateFormat dayFormatter = DateFormat('dd-MM-yyyy');
    final DateFormat monthFormatter = DateFormat('MM-yyyy');
    final DateFormat yearFormatter = DateFormat('yyyy');
    // Nếu cùng ngày, hiển thị giờ
    if (parsedDateTime.year == now.year &&
        parsedDateTime.month == now.month &&
        parsedDateTime.day == now.day) {
      return timeFormatter.format(parsedDateTime);
    }
    // Nếu cùng tháng, nhưng khác ngày, hiển thị ngày
    if (parsedDateTime.year == now.year && parsedDateTime.month == now.month) {
      return dayFormatter.format(parsedDateTime);
    }
    // Nếu cùng năm, nhưng khác tháng, hiển thị tháng
    if (parsedDateTime.year == now.year) {
      return monthFormatter.format(parsedDateTime);
    }
    // Nếu khác năm, hiển thị năm
    return yearFormatter.format(parsedDateTime);
  }

  Future<void> _sendMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getInt('userId'); // Lấy userId hiện tại
    final text = _messageController.text.trim();
    if (text.isNotEmpty && currentUserId != null) {
      final messageRequest = MessageSend(
        messageId: widget.messageId,
        userId: currentUserId,
        cv: 'đã gửi',
        content: text,
        sendingTime: DateTime.now().toIso8601String(),
      );
      try {
        await messageService.sendMessage(messageRequest);
        final newMessages =
            await messageService.getMessageDetail(widget.messageId).then(
          (messageDetails) {
            return messageDetails.map((message) {
              return {
                'text': message.content,
                'time': message.sendingTime,
                'isSentByMe': message.userId == currentUserId,
              };
            }).toList();
          },
        );
        setState(() {
          messages = Future.value(newMessages);
          _messageController.clear();
        });
        _scrollToBottom(); // Cuộn xuống cuối
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gửi tin nhắn thất bại. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tin nhắn không được để trống.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _viewCV() {
    // Điều hướng đến trang hiển thị CV của ứng viên hoặc thực hiện hành động khác
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFWebViewPage(pdfUrl: widget.filePath),
      ),
    );
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.user.avatar != '0'
                  ? NetworkImage(widget.user.avatar)
                  : AssetImage('images/default_profile.png') as ImageProvider,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.apllicantName,
                overflow: TextOverflow.ellipsis, // Đảm bảo tên không bị tràn
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          widget.user.cv != null && widget.user.cv!.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.description),
                  onPressed: _viewCV,
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Center(
                    child: Text(
                      'Chưa cập nhật CV',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages found'));
                }
                // Đảo ngược danh sách tin nhắn
                final messageList = snapshot.data!.reversed.toList();
                return ListView.builder(
                  reverse: true, // Đảm bảo luôn cuộn xuống cuối
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    final message = messageList[index];
                    return Align(
                      alignment: message['isSentByMe']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message['isSentByMe']
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: message['isSentByMe']
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(message['text']),
                            SizedBox(height: 5),
                            Text(
                              _formatDateTime(message['time']),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input gửi tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

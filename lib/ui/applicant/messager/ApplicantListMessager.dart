import 'package:dacn2/data/models/applicant.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/services/message_service.dart';
import 'package:dacn2/data/models/response/listmessageRespone.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';
import 'ApplicantChat.dart';

class ListMessPage extends StatefulWidget {
  ListMessPage({Key? key}) : super(key: key);
  @override
  ListMessPageState createState() => ListMessPageState();
}

class ListMessPageState extends State<ListMessPage> {
  void reloadPage() {
    setState(() {
      _loadMessages();
    });
  }

  late Future<User> futureUser;
  final UserService userService = UserService(baseUrl: Util.baseUrl);

  final MessageService messageService = MessageService(baseUrl: Util.baseUrl);
  List<Map<String, dynamic>> allMessagesWithUsers = [];
  List<Map<String, dynamic>> filteredMessagesWithUsers = [];
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final employerId = prefs.getInt('userId');
    if (employerId != null) {
      final fetchedMessages =
          await messageService.getListMessageByApplicantId(employerId);
      // Tải dữ liệu user và kết hợp với messages
      List<Map<String, dynamic>> combinedData = [];
      for (var message in fetchedMessages) {
        final user = await userService.getUserById(message.employerId);
        combinedData.add({'message': message, 'user': user});
      }

      setState(() {
        allMessagesWithUsers = combinedData;
        filteredMessagesWithUsers = allMessagesWithUsers;
      });
    } else {
      print('EmployerId ID is null');
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredMessagesWithUsers = allMessagesWithUsers.where((data) {
        final user = data['user'] as User;
        return user.fullName.toLowerCase().contains(searchQuery);
      }).toList();
    });
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
                const Color.fromARGB(255, 149, 223, 255),
                Colors.lightBlueAccent.shade400,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm tuyển dụng',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: filteredMessagesWithUsers.isEmpty
          ? Center(child: Text('Không có tin nhắn nào'))
          : ListView.builder(
              itemCount: filteredMessagesWithUsers.length,
              itemBuilder: (context, index) {
                final data = filteredMessagesWithUsers[index];
                final message = data['message'] as ListMessageRespone;
                final user = data['user'] as User;

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (message.avatarChat != "0"
                              ? NetworkImage(message.avatarUrl)
                              : AssetImage('images/default_profile.png'))
                          as ImageProvider,
                      radius: 25,
                    ),
                    title: Text(
                      user.fullName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("..."),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  messageId: message.messageId,
                                  employerName: user.fullName,
                                  message: message,
                                  user: user,
                                )),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

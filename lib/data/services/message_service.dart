import 'package:dacn2/data/models/message_request.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/data/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/models/response/postResponse.dart';
import '../models/response/listmessageRespone.dart';
import '../models/message_request.dart';
import '../models/request/message_send.dart';

class MessageService {
  final String baseUrl;
  MessageService({required this.baseUrl});

// Phương thức tạo Message
  Future<Map<String, dynamic>> createMessage(
      MessageRequest messageRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/message/create'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(messageRequest.toJson()), // Gửi toàn bộ MessageRequest
      );
      print('response: ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to create message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while creating message: $e');
    }
  }

  Future<List<ListMessageRespone>> getListMessageByApplicantId(
      int applicantId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/applicant/list/$applicantId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((e) => ListMessageRespone.fromJson(e)).toList();
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to get list message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while getting list message: $e');
    }
  }

  Future<List<ListMessageRespone>> getListMessageByEmploerId(
      int employerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/employer/list/$employerId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((e) => ListMessageRespone.fromJson(e)).toList();
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to get list message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while getting list message: $e');
    }
  }

  Future<List<MessageDetail>> getMessageDetail(int messageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/message_detail/$messageId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((e) => MessageDetail.fromJson(e)).toList();
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to get message detail: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while getting message detail: $e');
    }
  }

  Future<MessageSend> sendMessage(MessageSend messageSend) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/message_detail/save'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(messageSend.toJson()), // Gửi toàn bộ MessageSend
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          print('response: ${response.body}');
          final Map<String, dynamic> data = json.decode(response.body);
          return MessageSend.fromJson(data);
        } else {
          print('Empty response body: ${response.body}');
          throw Exception('Empty response body');
        }
      } else {
        print('Failed to send message:: ${response.body}');
        throw Exception('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending message:: ${e}');
      throw Exception('Error occurred while sending message: $e');
    }
  }
}

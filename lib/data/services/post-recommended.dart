import 'dart:convert';
import 'package:dacn2/data/models/response/postResponse.dart';
import 'package:http/http.dart' as http;

class RecommendedService {
  final String baseUrl;
  RecommendedService({required this.baseUrl});

  Future<List<PostResponse>> getPostRecommendByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employer/post/recommended/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      // print('response: ${response.body}');
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<dynamic> data =
              jsonDecode(utf8.decode(response.bodyBytes));
          return data.map((e) => PostResponse.fromJson(e)).toList();
        } else {
          throw Exception('Empty response body: ${response.statusCode}');
        }
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch posts: $e');
      throw Exception('Failed to fetch posts: $e');
    }
  }
}

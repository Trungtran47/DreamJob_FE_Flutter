import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/data/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/models/response/postResponse.dart';

class PostService {
  final String baseUrl;
  PostService({required this.baseUrl});

  Future<Post> savePost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/employer/post/create'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode(post.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> data = json.decode(response.body);
          return Post.fromJson(data);
        } else {
          throw Exception('Empty response body');
        }
      }
    } catch (e) {
      // print('Failed to save post: $e');
      throw Exception('Failed to have post: $e');
    }
    throw Exception('Unexpected error occurred');
  }

  Future<Post> updatePost(int id, Post post) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/employer/post/$id/update'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode(post.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          return Post.fromJson(jsonDecode(response.body));
        } else {
          print('Update successful but empty response body');
          return post; // Trả về đối tượng post đã cập nhật nếu máy chủ không trả về gì
        }
      } else {
        print('Failed to update post: ${response.statusCode}');
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to update post: $e');
      throw Exception('Failed to update post: $e');
    }
  }

  Future<Post> getPostById(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employer/post/$postId'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> data =
              jsonDecode(utf8.decode(response.bodyBytes));
          return Post.fromJson(data);
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to fetch post');
      }
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }

  Future<List<PostResponse>> getAllPostsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employer/post/all/$userId'),
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

  Future<void> deletePost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/employer/delete/post/$postId'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
      );
      if (response.statusCode == 204) {
        return "Post deleted successfully" as dynamic;
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<List<PostResponse>> getAllPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employer/applicant/post/all'),
        headers: {'Content-Type': 'application/json'},
      );
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

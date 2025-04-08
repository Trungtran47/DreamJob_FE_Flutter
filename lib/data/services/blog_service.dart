import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/Util.dart';
import 'dart:io';
import '../models/blog.dart';

class BlogService {
  final String baseUrl;

  BlogService({required this.baseUrl});
  Future<List<Blog>> getBlogs(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/blog/listByUserId/$userId'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => Blog.fromJson(e)).toList();
      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Blog> createBlog(Blog blog, File? imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/blog/create'),
      );
      request.fields['user'] = blog.user.toString();
      request.fields['title'] = blog.title;
      request.fields['content'] = blog.content;
      request.fields['author'] = blog.author!;
      request.fields['time'] = blog.time!;
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      return request.send().then((response) async {
        final body = await response.stream.bytesToString();
        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(body);
          return Blog.fromJson(data);
        } else {
          throw Exception(' $body');
        }
      });
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Blog> updateBlog(int blogId, Blog blog, File? imageFile) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/blog/updateBlog/$blogId'),
      );
      request.fields['user'] = blog.user.toString();
      request.fields['title'] = blog.title;
      request.fields['content'] = blog.content;
      request.fields['author'] = blog.author!;
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      return request.send().then((response) async {
        final body = await response.stream.bytesToString();
        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(body);
          return Blog.fromJson(data);
        } else {
          throw Exception(' $body');
        }
      });
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> deleteBlog(int blogId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/blog/deleteBlog/$blogId'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<List<Blog>> getAllBlogs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/blog/list'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => Blog.fromJson(e)).toList();
      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // Lấy blog cho admin
  Future<List<Blog>> getAllBlogsNoStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/blog/list'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => Blog.fromJson(e)).toList();
      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
  // cap nhat trang thai blog
  Future<Blog> updateStatusBlog(int blogId, int status) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/admin/blog/updateStatus/$blogId/$status'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return Blog.fromJson(data);
      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../models/company.dart';
import '../models/applicant.dart';
import '../util/Util.dart';
import 'dart:io';

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  Future<User> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception(' ${response.body}');
    }
  }

  Future<User> loginUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return User.fromJson(data);
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      print('Error occurred while logging in: $e');
      throw Exception('$e');
    }
  }

  Future<User> getUserById(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));

        // Kiểm tra và xử lý các giá trị có thể là null
        if (data['userId'] == null ||
            data['username'] == null ||
            data['email'] == null ||
            data['fullName'] == null) {
          throw Exception('Invalid user data');
        }
        // Cập nhật trường avatar với URL đầy đủ
        String imageUrl = '$baseUrl/uploads/'; // Địa chỉ cơ sở của bạn
        String avatarUrl =
            data['avatar'] != "0" ? imageUrl + data['avatar'] : '0';

        // Cập nhật avatar trong dữ liệu người dùng
        data['avatar'] = avatarUrl;
        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to get user by id: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching user: $e');
    }
  }

  Future<void> updateEmployer(int userId, User user, File? imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/user/$userId/update_employer'));

      // Thêm các trường thông tin người dùng vào request
      request.fields['username'] = user.username;
      request.fields['fullName'] = user.fullName;
      request.fields['phone'] = user.phone.toString();

      // Nếu có ảnh mới, thêm ảnh vào request
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      var response = await request.send();
      if (response.statusCode != 200) {
        var responseBody =
            await response.stream.bytesToString(); // Lấy nội dung phản hồi
        throw Exception(
            'Lỗi: ${response.statusCode} - Nội dung: $responseBody');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  Future<void> updateApplicant(int userId, User user, File? imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/user/$userId/update_applicant'));

      // Thêm các trường thông tin người dùng vào request
      request.fields['username'] = user.username;
      request.fields['fullName'] = user.fullName;
      request.fields['phone'] = user.phone.toString();
      request.fields['experience'] = user.experience;
      request.fields['desiredJob'] = user.desiredJob;
      request.fields['location'] = user.location;

      // Nếu có ảnh mới, thêm ảnh vào request
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }
      var response = await request.send();
      if (response.statusCode != 200) {
        var responseBody =
            await response.stream.bytesToString(); // Lấy nội dung phản hồi
        throw Exception(
            'Lỗi: ${response.statusCode} - Nội dung: $responseBody');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  Future<void> updateCv(int userId, File cvFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/user/update_cv/$userId/cv'));

      // Thêm file CV vào request
      request.files.add(await http.MultipartFile.fromPath('cv', cvFile.path));

      var response = await request.send();
      if (response.statusCode != 200) {
        var responseBody =
            await response.stream.bytesToString(); // Lấy nội dung phản hồi
        print('Lỗi: ${response.statusCode} - Nội dung: $responseBody');
        throw Exception(
            'Lỗi: ${response.statusCode} - Nội dung: $responseBody');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  Future<void> deleteCv(int userId) async {
    try {
      var response =
          await http.delete(Uri.parse('$baseUrl/user/delete_cv/$userId/cv'));

      if (response.statusCode != 200) {
        var responseBody = response.body; // Lấy nội dung phản hồi
        print('Lỗi: ${response.statusCode} - Nội dung: $responseBody');
        throw Exception(
            'Lỗi: ${response.statusCode} - Nội dung: $responseBody');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  // lấy danh sach tat ca user
  Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/user/getAll'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<User> users = data.map((e) => User.fromJson(e)).toList();
        return users;
      } else {
        throw Exception('Failed to get all users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching all users: $e');
    }
  }
  // Future<Company> registerEmployer(Company employer, File imageFile) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('$baseUrl/user/register/employer'));
  //   request.fields['userId'] = employer.userId.toString();
  //   request.fields['companyName'] = employer.companyName;
  //   request.fields['companyDescription'] = employer.companyDescription;
  //   request.fields['companyWebsite'] = employer.companyWebsite;
  //   request.fields['companyLocation'] = employer.companyLocation;
  //   request.fields['numberEmployees'] = employer.numberEmployees;
  //   request.files
  //       .add(await http.MultipartFile.fromPath('imageLogo', imageFile.path));

  //   var response = await request.send();

  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     final Map<String, dynamic> data = json.decode(responseBody);
  //     return Company.fromJson(data);
  //   } else {
  //     throw Exception('Failed to register employer');
  //   }
  // }

  // Future<Applicant> registerApplicant(Applicant applicant) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/user/register/applicant'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(applicant.toJson()),
  //   );

  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');

  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     if (response.body.isNotEmpty) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       return Applicant.fromJson(data);
  //     } else {
  //       throw Exception('Empty response body');
  //     }
  //   } else {
  //     throw Exception('Failed to register applicant: ${response.body}');
  //   }
  // }
}

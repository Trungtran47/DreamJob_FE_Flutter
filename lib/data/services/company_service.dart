import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CompanyService {
  final String baseUrl;
  CompanyService({required this.baseUrl});

  Future<Company> saveCompany(int userId, Company company, File? logo) async {
    try {
      print('userId: $userId');
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/company/save'));

      // Thêm các trường bắt buộc vào request.fields
      request.fields['userId'] = userId.toString();
      request.fields['companyName'] =
          company.companyName; // Thêm trường companyName
      request.fields['companyIntroduce'] = company.companyIntroduce;
      request.fields['companyLocation'] = company.companyLocation;
      request.fields['companyCategory'] = company.companyCategory;
      request.fields['companyWebsite'] = company.companyWebsite;
      request.fields['companySize'] = company.companySize;

      if (logo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('companyLogo', logo.path));
      }

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Company.fromJson(jsonDecode(responseString));
      } else {
        print('Lỗi: $responseString');
        throw Exception('Failed to save company');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  Future<Company> updateCompany(
      int companyId, int userId, Company company, File? logo) async {
    try {
      print('companyId: $companyId');
      var request = http.MultipartRequest(
          'PUT', Uri.parse('$baseUrl/company/update/$companyId'));

      // Thêm các trường bắt buộc vào request.fields
      request.fields['userId'] = userId.toString();
      request.fields['companyName'] =
          company.companyName; // Thêm trường companyName
      request.fields['companyIntroduce'] = company.companyIntroduce;
      request.fields['companyLocation'] = company.companyLocation;
      request.fields['companyCategory'] = company.companyCategory;
      request.fields['companyWebsite'] = company.companyWebsite;
      request.fields['companySize'] = company.companySize;

      if (logo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('companyLogo', logo.path));
      }
      print('request: logo.path: ${logo?.path}');
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Company.fromJson(jsonDecode(responseString));
      } else {
        print('Lỗi: $responseString');
        throw Exception('Failed to update company');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  Future<Company?> getCompanyByUserId(int userId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/company/$userId'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return Company.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to get company');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }

  Future<List<Company>> getAllCompanies() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/company/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => Company.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get company');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('$e');
    }
  }
}

import 'package:dacn2/data/models/admin/admin_dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AdminDashboardService {
  final String baseUrl;
  AdminDashboardService({required this.baseUrl});

  // Get admin dashboard statistics
  Future<AdminDashboard> getAdminDashboard() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/dashboard'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        return AdminDashboard.fromJson(data);

      } else {
        throw Exception(' ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

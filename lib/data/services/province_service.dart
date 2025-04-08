import 'package:dacn2/data/models/province.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProvinceService {
  final String baseUrl;
  ProvinceService({required this.baseUrl});

  Future<List<Province>> getAllProvinces() async {
    final response = await http.get(
      Uri.parse('$baseUrl/province/getAll'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Iterable jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((province) => Province.fromJson(province))
          .toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }
}

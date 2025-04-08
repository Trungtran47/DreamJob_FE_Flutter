import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  // API URLs
  final String provinceUrl = 'https://api.npoint.io/ac646cb54b295b9555be';
  final String districtUrl = 'https://api.npoint.io/34608ea16bebc5cffd42';
  final String wardUrl = 'https://api.npoint.io/dd278dc276e65c68cdf5';

  // Fetch provinces
  Future<List<String>> fetchProvinces() async {
    final response = await http.get(Uri.parse(provinceUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['name'] as String).toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  // Fetch districts based on selected province
  Future<List<String>> fetchDistricts(String provinceId) async {
    final response = await http.get(Uri.parse(districtUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .where((item) => item['province_id'] == provinceId)
          .map((item) => item['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }

  // Fetch wards based on selected district
  Future<List<String>> fetchWards(String districtId) async {
    final response = await http.get(Uri.parse(wardUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .where((item) => item['district_id'] == districtId)
          .map((item) => item['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to load wards');
    }
  }
}

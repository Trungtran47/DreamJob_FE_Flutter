import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/response/SavedJobResponse.dart';
import '../models/request/savedJobRequest.dart';
import '../models/response/postResponse.dart';

class SavedJobService {
  final String baseUrl;
  SavedJobService({required this.baseUrl});

  Future<List<PostResponse>> getAllSavedJobs(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/saved_job/list/$userId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((job) => PostResponse.fromJson(job)).toList();
    } else {
      print('Failed to load saved jobs ${response.statusCode}');
      throw Exception('Failed to load saved jobs');
    }
  }

  Future<SavedJobResponse> saveJob(SavedJobRequest savedJobRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/saved_job/save'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(savedJobRequest.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SavedJobResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save job');
    }
  }

  Future<void> deleteSavedJob(int userId, int postId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/user/saved_job/delete/$userId/$postId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    print('deleteSavedJob response: ${response.statusCode}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to delete saved job');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/course.dart';

class CourseApiService {
  CourseApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  final http.Client _client;

  Future<List<Course>> fetchCourses() async {
    final response = await _client.get(Uri.parse('$_baseUrl?_limit=10'));
    _ensureSuccess(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Course> addCourse(Course course) async {
    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );
    _ensureSuccess(response);
    return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Course> updateCourse(Course course) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/${course.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );
    _ensureSuccess(response);
    return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteCourse(int id) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/$id'));
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request failed with status ${response.statusCode}');
    }
  }
}


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/course.dart';

class CourseLocalStorage {
  static const _coursesKey = 'cached_courses';

  Future<void> saveCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    final data = courses.map((course) => course.toJson()).toList();
    await prefs.setString(_coursesKey, jsonEncode(data));
  }

  Future<List<Course>> loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final rawCourses = prefs.getString(_coursesKey);
    if (rawCourses == null) return [];

    final data = jsonDecode(rawCourses) as List<dynamic>;
    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}


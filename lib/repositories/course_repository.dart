import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/course.dart';
import '../services/api/course_api_service.dart';
import '../services/local/course_local_storage.dart';

class CourseRepository {
  CourseRepository({
    required CourseApiService apiService,
    required CourseLocalStorage localStorage,
    Connectivity? connectivity,
  })  : _apiService = apiService,
        _localStorage = localStorage,
        _connectivity = connectivity ?? Connectivity();

  final CourseApiService _apiService;
  final CourseLocalStorage _localStorage;
  final Connectivity _connectivity;

  Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<List<Course>> getCourses() async {
    final cachedCourses = await _localStorage.loadCourses();
    if (!await hasConnection) {
      return cachedCourses;
    }

    try {
      final remoteCourses = await _apiService.fetchCourses();
      await _localStorage.saveCourses(remoteCourses);
      return remoteCourses;
    } catch (_) {
      return cachedCourses;
    }
  }

  Future<Course> addCourse(Course course) async {
    if (!await hasConnection) {
      throw Exception('Cannot add a course while offline');
    }
    return _apiService.addCourse(course);
  }

  Future<Course> updateCourse(Course course) async {
    if (!await hasConnection) {
      throw Exception('Cannot update a course while offline');
    }
    return _apiService.updateCourse(course);
  }

  Future<void> deleteCourse(int id) async {
    if (!await hasConnection) {
      throw Exception('Cannot delete a course while offline');
    }
    await _apiService.deleteCourse(id);
  }

  Future<void> cacheCourses(List<Course> courses) {
    return _localStorage.saveCourses(courses);
  }
}


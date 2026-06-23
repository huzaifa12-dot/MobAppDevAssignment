import '../models/course.dart';
import '../services/api/course_api_service.dart';

class CourseRepository {
  CourseRepository({required CourseApiService apiService}) : _apiService = apiService;

  final CourseApiService _apiService;

  Future<List<Course>> getCourses() => _apiService.fetchCourses();
  Future<Course> addCourse(Course course) => _apiService.addCourse(course);
  Future<Course> updateCourse(Course course) => _apiService.updateCourse(course);
  Future<void> deleteCourse(int id) => _apiService.deleteCourse(id);
}

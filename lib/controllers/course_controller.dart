import 'package:flutter/material.dart';

import '../models/app_enums.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseController extends ChangeNotifier {
  CourseController(this._repository);

  final CourseRepository _repository;

  ViewStatus status = ViewStatus.initial;
  List<Course> courses = [];
  String? errorMessage;

  List<Course> filteredCourses(String query) {
    if (query.trim().isEmpty) return courses;
    final normalizedQuery = query.toLowerCase();
    return courses.where((course) {
      return course.title.toLowerCase().contains(normalizedQuery) ||
          course.description.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  Future<void> loadCourses() async {
    status = ViewStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      courses = await _repository.getCourses();
      status = courses.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (error) {
      status = ViewStatus.error;
      errorMessage = error.toString();
    }
    notifyListeners();
  }

  Future<void> addCourse(String title, String description) async {
    final temporaryCourse = Course(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
    );
    courses = [temporaryCourse, ...courses];
    status = ViewStatus.success;
    notifyListeners();

    try {
      final savedCourse = await _repository.addCourse(temporaryCourse);
      courses = [
        savedCourse.copyWith(id: temporaryCourse.id),
        ...courses.where((course) => course.id != temporaryCourse.id),
      ];
    } catch (error) {
      courses = courses.where((course) => course.id != temporaryCourse.id).toList();
      errorMessage = error.toString();
      status = courses.isEmpty ? ViewStatus.empty : ViewStatus.success;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateCourse(Course updatedCourse) async {
    final previousCourses = List<Course>.from(courses);
    courses = courses
        .map((course) => course.id == updatedCourse.id ? updatedCourse : course)
        .toList();
    notifyListeners();

    try {
      await _repository.updateCourse(updatedCourse);
    } catch (error) {
      courses = previousCourses;
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCourse(int id) async {
    final previousCourses = List<Course>.from(courses);
    courses = courses.where((course) => course.id != id).toList();
    status = courses.isEmpty ? ViewStatus.empty : ViewStatus.success;
    notifyListeners();

    try {
      await _repository.deleteCourse(id);
    } catch (error) {
      courses = previousCourses;
      status = ViewStatus.success;
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }
}


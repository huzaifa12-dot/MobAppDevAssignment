import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../utils/validators.dart';

class CourseFormScreen extends StatefulWidget {
  const CourseFormScreen({super.key, this.course});

  final Course? course;

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isSaving = false;

  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.course?.description ?? '',
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final controller = context.read<CourseController>();
    try {
      if (_isEditing) {
        await controller.updateCourse(
          widget.course!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ),
        );
      } else {
        await controller.addCourse(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save course. Try again online.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Course' : 'Add Course')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Course Title'),
                    validator: (value) => Validators.requiredField(value, 'Course title'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    minLines: 4,
                    maxLines: 8,
                    validator: (value) => Validators.requiredField(value, 'Description'),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: _isSaving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_isEditing ? 'Update Course' : 'Add Course'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


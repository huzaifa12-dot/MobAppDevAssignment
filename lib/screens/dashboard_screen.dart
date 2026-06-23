import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/course_controller.dart';
import '../models/app_enums.dart';
import '../models/course.dart';
import 'course_form_screen.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  final _subjects = const [
    Course(
      id: 201,
      title: 'Mobile App Development',
      description: 'Flutter, navigation, validation, APIs, local storage, and release-ready mobile UI.',
    ),
    Course(
      id: 202,
      title: 'Software Re-engineering',
      description: 'Legacy system analysis, refactoring, maintainability, and modernization practices.',
    ),
    Course(
      id: 203,
      title: 'Management Information Systems (MIS)',
      description: 'Information systems, decision support, enterprise workflows, and reporting.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await context.read<AuthController>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CourseFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Course'),
      ),
      body: RefreshIndicator(
        onRefresh: context.read<CourseController>().loadCourses,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    (user?.firstName.isNotEmpty ?? false)
                        ? user!.firstName[0].toUpperCase()
                        : 'S',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'Student',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Text('Course dashboard'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Subjects', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._subjects.map(
              (subject) => Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(subject.title),
                  subtitle: Text(subject.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(course: subject),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('API Courses', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search courses',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Consumer<CourseController>(
              builder: (context, controller, _) {
                final courses = controller.filteredCourses(_searchController.text);
                if (controller.status == ViewStatus.loading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (controller.status == ViewStatus.error) {
                  return _MessageState(
                    icon: Icons.error_outline,
                    message: controller.errorMessage ?? 'Unable to load courses',
                    actionLabel: 'Retry',
                    onAction: controller.loadCourses,
                  );
                }
                if (courses.isEmpty) {
                  return const _MessageState(
                    icon: Icons.inbox_outlined,
                    message: 'No courses found',
                  );
                }
                return Column(
                  children: courses.map((course) => _CourseTile(course: course)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CourseController>();
    return Card(
      child: ListTile(
        title: Text(course.title),
        subtitle: Text('ID: ${course.id}\n${course.description}'),
        isThreeLine: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(course: course)),
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: 'Edit course',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CourseFormScreen(course: course)),
              ),
            ),
            IconButton(
              tooltip: 'Delete course',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Course'),
                    content: Text('Delete "${course.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (shouldDelete != true || !context.mounted) return;
                try {
                  await controller.deleteCourse(course.id);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Delete failed. Changes restored.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}


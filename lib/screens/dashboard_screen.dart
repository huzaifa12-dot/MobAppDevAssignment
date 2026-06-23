import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../models/course.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  static const _subjects = [
    Course(id: 201, title: 'Mobile App Development', description: 'Flutter, navigation, validation, reusable widgets, and clean mobile UI.'),
    Course(id: 202, title: 'Software Re-engineering', description: 'Legacy system analysis, refactoring, maintainability, and modernization practices.'),
    Course(id: 203, title: 'Management Information Systems (MIS)', description: 'Information systems, decision support, enterprise workflows, and reporting.'),
  ];

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthController>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        IconButton(tooltip: 'Logout', onPressed: () => _logout(context), icon: const Icon(Icons.logout)),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            CircleAvatar(radius: 34, child: Text((user?.firstName.isNotEmpty ?? false) ? user!.firstName[0].toUpperCase() : 'S')),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?.fullName ?? 'Student', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const Text('Course dashboard'),
            ])),
          ]),
          const SizedBox(height: 24),
          Text('Subjects', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ..._subjects.map((subject) => Card(child: ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(subject.title),
            subtitle: Text(subject.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(course: subject))),
          ))),
        ],
      ),
    );
  }
}

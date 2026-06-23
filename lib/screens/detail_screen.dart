import 'package:flutter/material.dart';

import '../models/course.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Detail')),
      body: ListView(
        children: [
          Container(
            height: 190,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2B6C6F), Color(0xFFE09650)],
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: Text(
              course.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overview', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(course.description),
                const SizedBox(height: 24),
                Text('Schedule', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(Icons.calendar_month_outlined),
                  title: Text('Monday and Wednesday'),
                  subtitle: Text('10:00 AM - 11:30 AM'),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Computer Science Lab'),
                  subtitle: Text('Weekly practical session included'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


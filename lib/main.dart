import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/course_controller.dart';
import 'repositories/course_repository.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'services/api/course_api_service.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AssignmentApp());
}

class AssignmentApp extends StatelessWidget {
  const AssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(
          create: (_) => CourseRepository(apiService: CourseApiService()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthController(context.read<AuthService>())..loadSession(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CourseController(context.read<CourseRepository>())..loadCourses(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mobile App Development',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2B6C6F),
            primary: const Color(0xFF2B6C6F),
            secondary: const Color(0xFFE09650),
            surface: const Color(0xFFFFFBF4),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F2E9),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          useMaterial3: true,
        ),
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegistrationScreen.routeName: (_) => const RegistrationScreen(),
          DashboardScreen.routeName: (_) => const DashboardScreen(),
        },
        home: Consumer<AuthController>(
          builder: (context, auth, _) {
            if (auth.isAuthenticated) {
              return const DashboardScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}


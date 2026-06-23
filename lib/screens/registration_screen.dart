import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../models/app_enums.dart';
import '../models/app_user.dart';
import '../utils/validators.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Gender? _gender;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _firstNameController,
      _lastNameController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
    ]) {
      controller.addListener(_validateForm);
    }
  }

  void _validateForm() {
    final isValid = Validators.requiredField(_firstNameController.text, 'First name') == null &&
        Validators.requiredField(_lastNameController.text, 'Last name') == null &&
        Validators.email(_emailController.text) == null &&
        _gender != null &&
        Validators.password(_passwordController.text) == null &&
        Validators.confirmPassword(
              _confirmPasswordController.text,
              _passwordController.text,
            ) ==
            null;
    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _gender == null) return;

    final user = AppUser(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _gender!,
      password: _passwordController.text,
    );
    await context.read<AuthController>().register(user);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful. Please login.')),
    );
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Student Portal',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) => Validators.requiredField(value, 'First name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) => Validators.requiredField(value, 'Last name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Gender>(
                    value: _gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: Gender.values
                        .map(
                          (gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _gender = value);
                      _validateForm();
                    },
                    validator: (value) => value == null ? 'Gender is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _isValid ? _submit : null,
                    child: const Text('Register'),
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


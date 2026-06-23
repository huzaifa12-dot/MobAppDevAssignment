class Validators {
  const Validators._();

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, 'Email');
    if (requiredError != null) return requiredError;

    final emailPattern = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, 'Password');
    if (requiredError != null) return requiredError;

    final passwordValue = value!;
    if (passwordValue.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(passwordValue)) {
      return 'Password must include 1 uppercase letter';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\];]').hasMatch(passwordValue)) {
      return 'Password must include 1 special character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final requiredError = requiredField(value, 'Confirm password');
    if (requiredError != null) return requiredError;

    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}


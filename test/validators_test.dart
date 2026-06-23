import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev_assignments/utils/validators.dart';

void main() {
  test('email validator rejects invalid email', () {
    expect(Validators.email('wrong-email'), isNotNull);
  });

  test('password validator requires uppercase and special character', () {
    expect(Validators.password('abcdef'), isNotNull);
    expect(Validators.password('Abcdef!'), isNull);
  });

  test('confirm password must match', () {
    expect(Validators.confirmPassword('Secret!', 'Other!'), isNotNull);
    expect(Validators.confirmPassword('Secret!', 'Secret!'), isNull);
  });
}


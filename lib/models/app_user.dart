import 'app_enums.dart';

class AppUser {
  const AppUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final Gender gender;
  final String password;

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'gender': gender.name,
        'password': password,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      gender: Gender.values.firstWhere(
        (gender) => gender.name == json['gender'],
        orElse: () => Gender.other,
      ),
      password: json['password'] as String,
    );
  }
}


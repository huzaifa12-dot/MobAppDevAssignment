enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  const Gender(this.label);
  final String label;
}

enum AuthStatus { unknown, authenticated, unauthenticated }

enum ViewStatus { initial, loading, success, empty, error }


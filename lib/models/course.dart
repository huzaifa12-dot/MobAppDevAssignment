class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    this.userId = 1,
  });

  final int id;
  final String title;
  final String description;
  final int userId;

  Course copyWith({
    int? id,
    String? title,
    String? description,
    int? userId,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': description,
        'userId': userId,
      };

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      title: json['title'] as String,
      description: (json['body'] ?? json['description']) as String,
      userId: (json['userId'] ?? 1) as int,
    );
  }
}


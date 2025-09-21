class Stories {
  final String message;
  final List<Story> data;

  Stories({required this.message, required this.data});

  factory Stories.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = (json['data'] as List?) ?? const [];
    return Stories(
      message: (json['message'] as String?) ?? '',
      data: list
          .whereType<Map<String, dynamic>>()
          .map((e) => Story.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Story {
  final int id;
  final String photo;
  final String description;
  final String type;
  final bool isActive;
  final DateTime? createdAt;

  Story({
    required this.id,
    required this.photo,
    required this.description,
    required this.type,
    required this.isActive,
    required this.createdAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: (json['id'] as int?) ?? 0,
      photo: (json['photo'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      isActive: (json['is_active'] as bool?) ?? false,
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
      'description': description,
      'type': type,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

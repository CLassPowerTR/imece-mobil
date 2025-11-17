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
    return {'message': message, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class Story {
  final int id;
  final String photo;
  final String title;
  final String subtitle;
  final String description;
  final String banner;
  final String campaignType;
  final String type;
  final bool isActive;
  final int publishedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Story({
    required this.id,
    required this.photo,
    required this.banner,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.campaignType,
    required this.type,
    required this.publishedBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: (json['id'] as int?) ?? 0,
      photo: (json['photo'] as String?) ?? '',
      banner: (json['banner'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: (json['subtitle'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      campaignType: (json['campaign_type'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      isActive: (json['is_active'] as bool?) ?? false,
      createdAt: _parseDate(json['created_at']),
      publishedBy: (json['published_by'] as int?) ?? 0,
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
      'banner': banner,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'campaign_type': campaignType,
      'type': type,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'published_by': publishedBy,
      'updated_at': updatedAt?.toIso8601String(),
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

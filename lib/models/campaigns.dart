class Campaigns {
  final String message;
  final List<Campaign> data;

  Campaigns({required this.message, required this.data});

  factory Campaigns.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = (json['data'] as List?) ?? const [];
    return Campaigns(
      message: (json['message'] as String?) ?? '',
      data: list
          .whereType<Map<String, dynamic>>()
          .map((e) => Campaign.fromJson(e))
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

class Campaign {
  final int id;
  final String banner;
  final String campaignType;
  final String title;
  final String subtitle;
  final String description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Campaign({
    required this.id,
    required this.banner,
    required this.campaignType,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: (json['id'] as int?) ?? 0,
      banner: (json['banner'] as String?) ?? '',
      campaignType: (json['campaign_type'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: (json['subtitle'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      isActive: (json['is_active'] as bool?) ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner': banner,
      'campaign_type': campaignType,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
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

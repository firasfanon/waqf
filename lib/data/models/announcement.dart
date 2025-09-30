import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

enum Priority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
  @JsonValue('critical')
  critical,
}

@JsonSerializable()
class Announcement {
  final int id;
  final String title;
  final String content;
  final Priority priority;
  final DateTime? validUntil;
  final bool isActive;
  final String targetAudience;
  final int createdBy;
  final DateTime createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    this.validUntil,
    required this.isActive,
    required this.targetAudience,
    required this.createdBy,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  Announcement copyWith({
    int? id,
    String? title,
    String? content,
    Priority? priority,
    DateTime? validUntil,
    bool? isActive,
    String? targetAudience,
    int? createdBy,
    DateTime? createdAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      targetAudience: targetAudience ?? this.targetAudience,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Ù…Ù†Ø®ÙØ¶';
      case Priority.medium:
        return 'Ù…ØªÙˆØ³Ø·';
      case Priority.high:
        return 'Ø¹Ø§Ù„ÙŠ';
      case Priority.urgent:
        return 'Ø¹Ø§Ø¬Ù„';
      case Priority.critical:
        return 'Ø·Ø§Ø±Ø¦';
    }
  }

  String get displayNameEn {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
      case Priority.critical:
        return 'Critical';
    }
  }
}
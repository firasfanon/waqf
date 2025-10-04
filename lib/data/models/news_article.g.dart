// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) => NewsArticle(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] as String,
      category: $enumDecode(_$NewsCategoryEnumMap, json['category']),
      status: $enumDecode(_$PublishStatusEnumMap, json['status']),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NewsArticleToJson(NewsArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'author': instance.author,
      'category': _$NewsCategoryEnumMap[instance.category]!,
      'status': _$PublishStatusEnumMap[instance.status]!,
      'viewCount': instance.viewCount,
      'isFeatured': instance.isFeatured,
      'tags': instance.tags,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$NewsCategoryEnumMap = {
  NewsCategory.general: 'general',
  NewsCategory.mosques: 'mosques',
  NewsCategory.events: 'events',
  NewsCategory.education: 'education',
  NewsCategory.social: 'social',
  NewsCategory.religious: 'religious',
  NewsCategory.international: 'international',
  NewsCategory.administrative: 'administrative',
};

const _$PublishStatusEnumMap = {
  PublishStatus.draft: 'draft',
  PublishStatus.published: 'published',
  PublishStatus.archived: 'archived',
  PublishStatus.scheduled: 'scheduled',
};

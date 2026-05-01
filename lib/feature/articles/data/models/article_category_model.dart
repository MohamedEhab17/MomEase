import 'package:new_mama/feature/articles/domain/entities/article_category.dart';

class ArticleCategoryModel extends ArticleCategory {
  ArticleCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.count,
  });

  factory ArticleCategoryModel.fromJson(Map<String, dynamic> json) {
    return ArticleCategoryModel(
      id: json['categoryId'] as int? ?? json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['imageUrl'] as String? ?? json['image'] as String? ?? '',
      count: json['articlesCount'] as int? ?? json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'count': count,
    };
  }

  ArticleCategory toEntity() {
    return ArticleCategory(
      id: id,
      name: name,
      description: description,
      image: image,
      count: count,
    );
  }
}

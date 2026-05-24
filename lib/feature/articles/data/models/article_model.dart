import 'package:new_mama/feature/articles/domain/entities/article.dart';

class ArticleModel extends Article {
  ArticleModel({
    required super.articleId,
    required super.title,
    required super.imageUrl,
    required super.shortDescription,
    required super.categoryName,
    required super.categoryId,
    required super.readingTimeMinutes,
    required super.isSaved,
    super.content,
    super.publishedDate,
    super.sourceUrl,
    super.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final String shortDescription = json['shortDescription'] as String? ?? '';
    final String? content = json['content'] as String?;

    return ArticleModel(
      articleId: json['articleId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      shortDescription: shortDescription.isEmpty
          ? (content != null
              ? (content.length > 150
                  ? '${content.substring(0, 150)}...'
                  : content)
              : '')
          : shortDescription,
      categoryName: json['categoryName'] as String? ?? '',
      categoryId: json['categoryId'] as int? ?? 0,
      readingTimeMinutes: json['readingTimeMinutes'] as int? ?? 0,
      isSaved: json['isSaved'] as bool? ?? false,
      content: content ?? shortDescription,
      publishedDate: json['publishedDate'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      sourceName: json['sourceName'] as String?,
    );
  }

  @override
  ArticleModel copyWith({
    int? articleId,
    String? title,
    String? imageUrl,
    String? shortDescription,
    String? categoryName,
    int? categoryId,
    int? readingTimeMinutes,
    bool? isSaved,
    String? content,
    String? publishedDate,
    String? sourceUrl,
    String? sourceName,
  }) {
    return ArticleModel(
      articleId: articleId ?? this.articleId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      shortDescription: shortDescription ?? this.shortDescription,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      isSaved: isSaved ?? this.isSaved,
      content: content ?? this.content,
      publishedDate: publishedDate ?? this.publishedDate,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceName: sourceName ?? this.sourceName,
    );
  }

  Article toEntity() {
    return Article(
      articleId: articleId,
      title: title,
      imageUrl: imageUrl,
      shortDescription: shortDescription,
      categoryName: categoryName,
      isSaved: isSaved,
      categoryId: categoryId,
      readingTimeMinutes: readingTimeMinutes,
      content: content,
      publishedDate: publishedDate,
      sourceUrl: sourceUrl,
      sourceName: sourceName,
    );
  }
}

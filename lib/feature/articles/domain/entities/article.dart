class Article {
  final int articleId;
  final String title;
  final String imageUrl;
  final String shortDescription;
  final String categoryName;
  final bool isSaved;
  final int categoryId;
  final int readingTimeMinutes;
  final String? content;
  final String? publishedDate;
  final String? sourceUrl;
  final String? sourceName;

  Article({
    required this.articleId,
    required this.title,
    required this.imageUrl,
    required this.shortDescription,
    required this.categoryName,
    required this.isSaved,
    required this.categoryId,
    required this.readingTimeMinutes,
    this.content,
    this.publishedDate,
    this.sourceUrl,
    this.sourceName,
  });

  Article copyWith({
    int? articleId,
    String? title,
    String? imageUrl,
    String? shortDescription,
    String? categoryName,
    bool? isSaved,
    int? categoryId,
    int? readingTimeMinutes,
    String? content,
    String? publishedDate,
    String? sourceUrl,
    String? sourceName,
  }) {
    return Article(
      articleId: articleId ?? this.articleId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      shortDescription: shortDescription ?? this.shortDescription,
      categoryName: categoryName ?? this.categoryName,
      isSaved: isSaved ?? this.isSaved,
      categoryId: categoryId ?? this.categoryId,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      content: content ?? this.content,
      publishedDate: publishedDate ?? this.publishedDate,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceName: sourceName ?? this.sourceName,
    );
  }

  List<Object?> get props => [
        articleId,
        title,
        imageUrl,
        shortDescription,
        categoryName,
        isSaved,
        categoryId,
        readingTimeMinutes,
        content,
        publishedDate,
        sourceUrl,
        sourceName,
      ];
}

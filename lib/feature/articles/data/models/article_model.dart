class ArticleModel {
  final String id;
  final String category;
  final String title;
  final String authorName;
  final String date;
  final String readTime;
  final String imageUrl;
  final String overview;
  final List<ArticleSection> sections;
  final bool isSaved;
  final String authorImageUrl;

  ArticleModel({
    required this.id,
    required this.category,
    required this.title,
    required this.authorName,
    required this.date,
    required this.readTime,
    required this.imageUrl,
    required this.overview,
    required this.sections,
    this.isSaved = false,
    this.authorImageUrl = '',
  });

  ArticleModel copyWith({
    String? id,
    String? category,
    String? title,
    String? authorName,
    String? date,
    String? readTime,
    String? imageUrl,
    String? overview,
    List<ArticleSection>? sections,
    bool? isSaved,
    String? authorImageUrl,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      date: date ?? this.date,
      readTime: readTime ?? this.readTime,
      imageUrl: imageUrl ?? this.imageUrl,
      overview: overview ?? this.overview,
      sections: sections ?? this.sections,
      isSaved: isSaved ?? this.isSaved,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
    );
  }
}

class ArticleSection {
  final String? heading;
  final String? content;
  final List<String>? bulletPoints;

  ArticleSection({this.heading, this.content, this.bulletPoints});
}

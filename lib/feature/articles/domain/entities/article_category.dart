class ArticleCategory {
  final int id;
  final String name;
  final String description;
  final String image;
  final int count;
  ArticleCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.count,
  });
  List<Object?> get props => [id, name, description, image, count];

}
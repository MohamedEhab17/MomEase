class PostModel {
  final String id;
  final String userName;
  final String userImage;
  final String text;
  final List<String> images;
  final int likes;
  final int comments;
  final int saves;
  final bool isLiked;
  final bool isSaved;

  const PostModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.text,
    this.images = const [],
    required this.likes,
    required this.comments,
    required this.saves,
    required this.isLiked,
    required this.isSaved,
  });
    PostModel copyWith({
    int? likes,
    bool? isLiked,
    bool? isSaved,
    int? comments,
    int? saves,
  }) {
    return PostModel(
      id: id,
      userName: userName,
      userImage: userImage,
      text: text,
      images: images,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      saves: saves ?? this.saves,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

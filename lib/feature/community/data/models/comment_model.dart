class CommentModel {
  final String profileUrl;
  final String name;
  final String timeAgo;
  final String comment;
  final int likes;
  final bool isLiked;
  final List<CommentModel> repliesList;

  CommentModel({
    required this.profileUrl,
    required this.name,
    required this.timeAgo,
    required this.comment,
    required this.likes,
    this.isLiked = false,
    this.repliesList = const [],
  });

  int get replies => repliesList.length;

  CommentModel copyWith({
    String? profileUrl,
    String? name,
    String? timeAgo,
    String? comment,
    int? likes,
    bool? isLiked,
    List<CommentModel>? repliesList,
  }) {
    return CommentModel(
      profileUrl: profileUrl ?? this.profileUrl,
      name: name ?? this.name,
      timeAgo: timeAgo ?? this.timeAgo,
      comment: comment ?? this.comment,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      repliesList: repliesList ?? this.repliesList,
    );
  }
}

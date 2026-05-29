class ReactionModel {
  final int reactionId;
  final int postId;
  final int userId;
  final String userName;
  final String reactionType;
  final String? userPhoto;

  const ReactionModel({
    required this.reactionId,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.reactionType,
    this.userPhoto,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      reactionId: (json['reactionId'] as num?)?.toInt() ?? 0,
      postId: (json['postId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      userName: json['userName']?.toString() ?? '',
      reactionType: json['reactionType']?.toString() ?? '',
      userPhoto: json['userPhoto']?.toString(),
    );
  }
}

import 'package:new_mama/feature/community/data/models/reply_model.dart';

class CommentModel {
  final int commentId;
  final int postId;
  final int userId;
  final String userName;
  final String? userPhoto;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isMyComment;
  final bool canDelete;
  final int repliesCount;
  final int reactionsCount;
  final String? myReaction;

  // Local UI state — not from API
  final List<ReplyModel>? loadedReplies; // null=not fetched, []=fetched but empty
  final bool isLoadingReplies;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.text,
    required this.createdAt,
    this.updatedAt,
    required this.isMyComment,
    required this.canDelete,
    required this.repliesCount,
    required this.reactionsCount,
    this.myReaction,
    this.loadedReplies,
    this.isLoadingReplies = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        commentId: json['commentId'] as int,
        postId: json['postId'] as int,
        userId: json['userId'] as int,
        userName: json['userName']?.toString() ?? '',
        userPhoto: json['userPhoto']?.toString(),
        text: json['text']?.toString() ?? '',
        createdAt: DateTime.parse(json['createdAt'].toString()),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'].toString())
            : null,
        isMyComment: json['isMyComment'] as bool? ?? false,
        canDelete: json['canDelete'] as bool? ?? false,
        repliesCount: json['repliesCount'] as int? ?? 0,
        reactionsCount: json['reactionsCount'] as int? ?? 0,
        myReaction: json['myReaction']?.toString(),
      );

  CommentModel copyWith({
    int? commentId,
    int? postId,
    int? userId,
    String? userName,
    String? userPhoto,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isMyComment,
    bool? canDelete,
    int? repliesCount,
    int? reactionsCount,
    String? myReaction,
    bool clearMyReaction = false,
    List<ReplyModel>? loadedReplies,
    bool clearLoadedReplies = false,
    bool? isLoadingReplies,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isMyComment: isMyComment ?? this.isMyComment,
      canDelete: canDelete ?? this.canDelete,
      repliesCount: repliesCount ?? this.repliesCount,
      reactionsCount: reactionsCount ?? this.reactionsCount,
      myReaction: clearMyReaction ? null : (myReaction ?? this.myReaction),
      loadedReplies: clearLoadedReplies ? null : (loadedReplies ?? this.loadedReplies),
      isLoadingReplies: isLoadingReplies ?? this.isLoadingReplies,
    );
  }
}

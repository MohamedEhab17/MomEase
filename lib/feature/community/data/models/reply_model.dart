class ReplyModel {
  final int replyId;
  final int commentId;
  final int userId;
  final String userName;
  final String? userPhoto;
  final String text;
  final bool isMyReply;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReplyModel({
    required this.replyId,
    required this.commentId,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.text,
    required this.isMyReply,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
        replyId: json['replyId'] as int,
        commentId: json['commentId'] as int,
        userId: json['userId'] as int,
        userName: json['userName']?.toString() ?? '',
        userPhoto: json['userPhoto']?.toString(),
        text: json['text']?.toString() ?? '',
        isMyReply: json['isMyReply'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'].toString()),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'].toString())
            : null,
      );

  ReplyModel copyWith({
    int? replyId,
    int? commentId,
    int? userId,
    String? userName,
    String? userPhoto,
    String? text,
    bool? isMyReply,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReplyModel(
      replyId: replyId ?? this.replyId,
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      text: text ?? this.text,
      isMyReply: isMyReply ?? this.isMyReply,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

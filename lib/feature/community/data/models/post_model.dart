class PostModel {
  final int postId;
  final int userId;
  final String userName;
  final String? userPhoto;
  final String text;
  final List<PostMedia> media;
  final int commentsCount;
  final int reactionsCount;
  final String? myReaction;
  final bool isSaved;
  final bool isMyPost;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.text,
    this.media = const [],
    required this.commentsCount,
    required this.reactionsCount,
    this.myReaction,
    this.isSaved = false,
    this.isMyPost = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: _toInt(json['postId']),
      userId: _toInt(json['userId']),
      userName: json['userName']?.toString() ?? '',
      userPhoto: json['userPhoto']?.toString(),
      text: json['text']?.toString() ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => PostMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      commentsCount: _toInt(json['commentsCount']),
      reactionsCount: _toInt(json['reactionsCount']),
      myReaction: json['myReaction']?.toString(),
      isSaved: _toBool(json['isSaved']),
      isMyPost: _toBool(json['isMyPost']),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString()) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'text': text,
      'media': media.map((e) => e.toJson()).toList(),
      'commentsCount': commentsCount,
      'reactionsCount': reactionsCount,
      'myReaction': myReaction,
      'isSaved': isSaved,
      'isMyPost': isMyPost,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  PostModel copyWith({
    int? postId,
    int? userId,
    String? userName,
    String? userPhoto,
    String? text,
    List<PostMedia>? media,
    int? commentsCount,
    int? reactionsCount,
    String? myReaction,
    bool clearReaction = false,
    bool? isSaved,
    bool? isMyPost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      text: text ?? this.text,
      media: media ?? this.media,
      commentsCount: commentsCount ?? this.commentsCount,
      reactionsCount: reactionsCount ?? this.reactionsCount,
      myReaction: clearReaction ? null : (myReaction ?? this.myReaction),
      isSaved: isSaved ?? this.isSaved,
      isMyPost: isMyPost ?? this.isMyPost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PostMedia {
  final int mediaId;
  final String mediaUrl;
  final int mediaType;

  const PostMedia({
    required this.mediaId,
    required this.mediaUrl,
    required this.mediaType,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(
      mediaId: PostModel._toInt(json['mediaId']),
      mediaUrl: json['mediaUrl']?.toString() ?? '',
      mediaType: PostModel._toInt(json['mediaType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
    };
  }
}

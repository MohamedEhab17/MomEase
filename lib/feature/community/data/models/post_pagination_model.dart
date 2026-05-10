import 'post_model.dart';

class PostPaginationModel {
  final List<PostModel> posts;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PostPaginationModel({
    required this.posts,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PostPaginationModel.fromJson(Map<String, dynamic> json) {
    return PostPaginationModel(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalCount: _toInt(json['totalCount']),
      pageNumber: _toInt(json['pageNumber'], defaultValue: 1),
      pageSize: _toInt(json['pageSize'], defaultValue: 10),
      hasNextPage: _toBool(json['hasNextPage']),
      hasPreviousPage: _toBool(json['hasPreviousPage']),
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value == 1;
    return false;
  }
}

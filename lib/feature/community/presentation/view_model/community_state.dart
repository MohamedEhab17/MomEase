import 'package:equatable/equatable.dart';
import '../../data/models/post_model.dart';

enum CommunityStatus { initial, loading, success, loadingMore, error }

class CommunityState extends Equatable {
  final List<PostModel> posts;
  final CommunityStatus status;
  final String? errorMessage;
  final int pageNumber;
  final bool hasNextPage;
  final int totalCount;

  const CommunityState({
    this.posts = const [],
    this.status = CommunityStatus.initial,
    this.errorMessage,
    this.pageNumber = 1,
    this.hasNextPage = true,
    this.totalCount = 0,
  });

  CommunityState copyWith({
    List<PostModel>? posts,
    CommunityStatus? status,
    String? errorMessage,
    int? pageNumber,
    bool? hasNextPage,
    int? totalCount,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      pageNumber: pageNumber ?? this.pageNumber,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        status,
        errorMessage,
        pageNumber,
        hasNextPage,
        totalCount,
      ];
}
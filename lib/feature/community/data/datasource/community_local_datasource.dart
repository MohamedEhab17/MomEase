import 'package:injectable/injectable.dart';
import '../../data/models/post_model.dart';
import '../../dummy/dummy_post.dart';

abstract class CommunityLocalDataSource {
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10});
}

@LazySingleton(as: CommunityLocalDataSource)
class CommunityLocalDataSourceImpl implements CommunityLocalDataSource {
  @override
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final startIndex = page * limit;
    if (startIndex >= dummyPosts.length) {
      return [];
    }
    return dummyPosts.skip(startIndex).take(limit).toList();
  }
}

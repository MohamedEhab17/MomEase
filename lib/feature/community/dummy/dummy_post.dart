import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/dummy/dummy_text.dart';

final dummyPosts = List.generate(100, (i) {
  // Determine number of images based on index to test all layouts (0 to 5+ images)
  final imageCount = i % 6;
  final media = List.generate(
    imageCount,
    (imgIdx) => PostMedia(
      mediaId: imgIdx,
      mediaUrl: 'https://picsum.photos/600/600?random=${i * 10 + imgIdx}',
      mediaType: 0,
    ),
  );

  return PostModel(
    postId: i,
    userId: i + 1,
    userName: 'User $i',
    userPhoto: 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
    text: dummyTexts[i % dummyTexts.length],
    media: media,
    reactionsCount: 10 * i,
    commentsCount: i,
    createdAt: DateTime.now().subtract(Duration(hours: i)),
  );
});

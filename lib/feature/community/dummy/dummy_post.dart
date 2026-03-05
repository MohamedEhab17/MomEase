import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/dummy/dummy_text.dart';

final dummyPosts = List.generate(100, (i) {
  // Determine number of images based on index to test all layouts (0 to 5+ images)
  final imageCount = i % 6;
  final images = List.generate(
    imageCount,
    (imgIdx) => 'https://picsum.photos/600/600?random=${i * 10 + imgIdx}',
  );

  return PostModel(
    id: '$i',
    userName: 'Ana Soso',
    userImage: 'https://i.pravatar.cc/150?img=${i + 1}',
    text: dummyTexts[i % dummyTexts.length],
    images: images,
    likes: 10 * i,
    comments: i,
    saves: 5 * i,
    isLiked: false,
    isSaved: false,
  );
});

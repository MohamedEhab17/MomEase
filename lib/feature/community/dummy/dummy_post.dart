import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/dummy/dummy_text.dart';

final dummyPosts = List.generate(
  100,
  (i) => PostModel(
    id: '$i',
    userName: 'Ana Soso',
    userImage: 'https://i.pravatar.cc/150?img=${i + 1}',
    text: dummyTexts[i % dummyTexts.length],
    image: i.isEven ? 'https://picsum.photos/400/300?random=$i' : null,
    likes: 10 * i,
    comments: i,
    saves: 5 * i,
    isLiked: false,
    isSaved: false,
  ),
);

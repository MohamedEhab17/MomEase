import 'package:injectable/injectable.dart';
import '../../data/models/article_model.dart';
import '../../dummy/article_dummy_data.dart';

abstract class ArticleLocalDataSource {
  Future<List<ArticleModel>> getArticles();
}

@LazySingleton(as: ArticleLocalDataSource)
class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  @override
  Future<List<ArticleModel>> getArticles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return dummyArticles;
  }
}

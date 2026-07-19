import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/articles/domain/usecases/article_usecases.dart';
import 'package:new_mama/feature/articles/domain/usecases/get_articles_category_usecase.dart';

import 'home_articles_state.dart';

@injectable
class HomeArticlesCubit extends SafeCubit<HomeArticlesState> {
  final GetArticlesCategoryUsecase _getCategoriesUseCase;
  final GetArticlesByCategoryUseCase _getArticlesByCategoryUseCase;

  HomeArticlesCubit(
    this._getCategoriesUseCase,
    this._getArticlesByCategoryUseCase,
  ) : super(HomeArticlesInitial());

  Future<void> loadHomeArticles() async {
    safeEmit(HomeArticlesLoading());

    final categoriesResult = await cancelableOperation(_getCategoriesUseCase()).value;

    categoriesResult.fold(
      (failure) => safeEmit(HomeArticlesFailure(failure.message)),
      (categories) async {
        if (categories.isEmpty) {
          safeEmit(const HomeArticlesFailure('No categories available'));
          return;
        }

        final firstCategory = categories.first;
        final articlesResult = await cancelableOperation(
          _getArticlesByCategoryUseCase(firstCategory.id),
        ).value;

        articlesResult.fold(
          (failure) => safeEmit(HomeArticlesFailure(failure.message)),
          (articles) => safeEmit(
            HomeArticlesSuccess(articles.take(10).toList(), firstCategory.name),
          ),
        );
      },
    );
  }
}

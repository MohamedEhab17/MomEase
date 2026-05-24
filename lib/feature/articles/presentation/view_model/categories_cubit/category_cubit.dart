import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/articles/domain/usecases/get_articles_category_usecase.dart';
import 'package:new_mama/feature/articles/presentation/view_model/categories_cubit/category_state.dart';

@injectable
class CategoryCubit extends SafeCubit<CategoryState> {
  final GetArticlesCategoryUsecase _getArticlesCategory;

  CategoryCubit(this._getArticlesCategory)
      : super(CategoryInitial());

  void fetchArticlesCategory() {
    safeEmit(CategoryLoading());

    cancelableOperation(_getArticlesCategory()).value.then((result) {
      result.fold(
        (failure) => safeEmit(CategoryError(failure.message)),
        (data) => safeEmit(CategoryLoaded(data)),
      );
    });
  }
}
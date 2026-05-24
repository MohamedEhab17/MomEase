import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/community/domain/usecase/community_usecases.dart';
import 'post_details_state.dart';

@injectable
class PostDetailsCubit extends SafeCubit<PostDetailsState> {
  final GetPostByIdUseCase _getPostByIdUseCase;

  PostDetailsCubit(this._getPostByIdUseCase) : super(const PostDetailsState());

  Future<void> fetchPostDetails(int postId) async {
    safeEmit(state.copyWith(status: PostDetailsStatus.loading));

    final result = await _getPostByIdUseCase(postId);

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: PostDetailsStatus.error,
        errorMessage: failure.message,
      )),
      (post) => safeEmit(state.copyWith(
        status: PostDetailsStatus.success,
        post: post,
      )),
    );
  }
}

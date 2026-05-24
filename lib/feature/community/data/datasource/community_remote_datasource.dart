import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/localization/cubit/language_cubit.dart';
import '../../../../core/error/exceptions.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/post_pagination_model.dart';
import '../models/reaction_model.dart';
import '../models/reply_model.dart';

abstract class CommunityRemoteDataSource {
  Future<PostPaginationModel> getPosts({required int pageNumber, required int pageSize});
  Future<PostPaginationModel> getMyPosts({required int pageNumber, required int pageSize});
  Future<PostModel> getPostById(int id);
  Future<PostModel> createPost({required String text, List<String>? mediaFiles});
  Future<PostModel> updatePost({
    required int id,
    required String text,
    List<int>? mediaIdsToDelete,
    List<String>? newMediaFiles,
  });
  Future<void> deletePost(int id);
  Future<void> toggleSavePost({required int id, required bool save});
  Future<List<PostModel>> getSavedPosts();
  Future<void> reportPost({required int postId, required String reason});
  Future<void> addReaction({required int postId, required String reactionType});
  Future<void> updateReaction({required int postId, required String reactionType});
  Future<void> removeReaction({required int postId});
  Future<List<ReactionModel>> getPostReactions({required int postId});
  // Comments
  Future<List<CommentModel>> getComments({required int postId});
  Future<CommentModel> addComment({required int postId, required String text});
  Future<CommentModel> updateComment({required int postId, required int commentId, required String text});
  Future<void> deleteComment({required int postId, required int commentId});
  Future<ReactionModel> addCommentReaction({required int postId, required int commentId, required String reactionType});
  Future<ReactionModel> updateCommentReaction({required int postId, required int commentId, required String reactionType});
  Future<void> removeCommentReaction({required int postId, required int commentId});
  // Replies
  Future<List<ReplyModel>> getReplies({required int postId, required int commentId});
  Future<ReplyModel> addReply({required int postId, required int commentId, required String text});
  Future<ReplyModel> updateReply({required int postId, required int commentId, required int replyId, required String text});
  Future<void> deleteReply({required int postId, required int commentId, required int replyId});
}

@LazySingleton(as: CommunityRemoteDataSource)
class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final ApiClient _apiClient;

  CommunityRemoteDataSourceImpl(this._apiClient);

  Options get _headers => Options(
        headers: {'Accept-Language': getIt<LanguageCubit>().state.languageCode},
      );

  dynamic _normalizeData(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'];
    }
    return data;
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          return errors.values.first.toString();
        }
        return errors.toString();
      }
    }
    return 'An unknown server error occurred.';
  }

  @override
  Future<PostPaginationModel> getPosts({required int pageNumber, required int pageSize}) async {
    try {
      final response = await _apiClient.get(
        Api.communityPosts,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
        options: _headers,
      );
      return PostPaginationModel.fromJson(_normalizeData(response.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostPaginationModel> getMyPosts({required int pageNumber, required int pageSize}) async {
    try {
      final response = await _apiClient.get(
        Api.myPosts,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
        options: _headers,
      );
      return PostPaginationModel.fromJson(_normalizeData(response.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await _apiClient.get(Api.communityPostById(id), options: _headers);
      return PostModel.fromJson(_normalizeData(response.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> createPost({required String text, List<String>? mediaFiles}) async {
    try {
      final formData = FormData.fromMap({
        'Text': text,
      });

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          formData.files.add(MapEntry(
            'MediaFiles',
            await MultipartFile.fromFile(file),
          ));
        }
      }

      final response = await _apiClient.post(
        Api.communityPosts,
        data: formData,
        options: _headers,
      );

      final data = _normalizeData(response.data);
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(data));
      }

      return PostModel.fromJson(data);
    } on DioException catch (e) {
      final message = _extractErrorMessage(e.response?.data);
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostModel> updatePost({
    required int id,
    required String text,
    List<int>? mediaIdsToDelete,
    List<String>? newMediaFiles,
  }) async {
    try {
      final formData = FormData.fromMap({
        'Text': text,
      });

      if (mediaIdsToDelete != null && mediaIdsToDelete.isNotEmpty) {
        for (var mediaId in mediaIdsToDelete) {
          formData.fields.add(MapEntry('MediaIdsToDelete', mediaId.toString()));
        }
      }

      if (newMediaFiles != null && newMediaFiles.isNotEmpty) {
        for (var file in newMediaFiles) {
          formData.files.add(MapEntry(
            'NewMediaFiles',
            await MultipartFile.fromFile(file),
          ));
        }
      }

      final response = await _apiClient.put(
        Api.communityPostById(id),
        data: formData,
        options: _headers,
      );

      final data = _normalizeData(response.data);
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(data));
      }

      return PostModel.fromJson(data);
    } on DioException catch (e) {
      final message = _extractErrorMessage(e.response?.data);
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      final response = await _apiClient.delete(Api.communityPostById(id), options: _headers);
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      final message = _extractErrorMessage(e.response?.data);
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> toggleSavePost({required int id, required bool save}) async {
    try {
      final response = save
          ? await _apiClient.post(Api.toggleSavePost(id), options: _headers)
          : await _apiClient.delete(Api.toggleSavePost(id), options: _headers);

      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      final message = _extractErrorMessage(e.response?.data);
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getSavedPosts() async {
    try {
      final response = await _apiClient.get(Api.savedPosts, options: _headers);
      final data = _normalizeData(response.data);
      if (data is List) {
        return data.map((e) {
          final postData = e['post'] as Map<String, dynamic>;
          return PostModel.fromJson(postData).copyWith(isSaved: true);
        }).toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> reportPost({required int postId, required String reason}) async {
    try {
      final response = await _apiClient.post(
        Api.reportPost(postId),
        data: {'reason': reason},
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      final message = _extractErrorMessage(e.response?.data);
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addReaction({required int postId, required String reactionType}) async {
    try {
      final response = await _apiClient.post(
        Api.postReactions(postId),
        data: {'reactionType': reactionType},
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateReaction({required int postId, required String reactionType}) async {
    try {
      final response = await _apiClient.put(
        Api.postReactions(postId),
        data: {'reactionType': reactionType},
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeReaction({required int postId}) async {
    try {
      final response = await _apiClient.delete(
        Api.postReactions(postId),
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ReactionModel>> getPostReactions({required int postId}) async {
    try {
      final response = await _apiClient.get(
        Api.postReactions(postId),
        options: _headers,
      );
      final data = _normalizeData(response.data);
      if (data is List) {
        return data
            .map((e) => ReactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CommentModel>> getComments({required int postId}) async {
    try {
      final response = await _apiClient.get(
        Api.postComments(postId),
        options: _headers,
      );
      final data = _normalizeData(response.data);
      if (data is List) {
        return data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> addComment({required int postId, required String text}) async {
    try {
      final response = await _apiClient.post(
        Api.postComments(postId),
        data: {'text': text},
        options: _headers,
      );
      final data = _normalizeData(response.data);
      return CommentModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> updateComment({required int postId, required int commentId, required String text}) async {
    try {
      final response = await _apiClient.put(
        Api.postCommentById(postId, commentId),
        data: {'text': text},
        options: _headers,
      );
      final data = _normalizeData(response.data);
      return CommentModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteComment({required int postId, required int commentId}) async {
    try {
      final response = await _apiClient.delete(
        Api.postCommentById(postId, commentId),
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReactionModel> addCommentReaction({required int postId, required int commentId, required String reactionType}) async {
    try {
      final response = await _apiClient.post(
        Api.commentReactions(postId, commentId),
        data: {'reactionType': reactionType},
        options: _headers,
      );
      final data = _normalizeData(response.data);
      return ReactionModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReactionModel> updateCommentReaction({required int postId, required int commentId, required String reactionType}) async {
    try {
      final response = await _apiClient.put(
        Api.commentReactions(postId, commentId),
        data: {'reactionType': reactionType},
        options: _headers,
      );
      final data = _normalizeData(response.data);
      return ReactionModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeCommentReaction({required int postId, required int commentId}) async {
    try {
      final response = await _apiClient.delete(
        Api.commentReactions(postId, commentId),
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ReplyModel>> getReplies({required int postId, required int commentId}) async {
    try {
      final response = await _apiClient.get(
        Api.commentReplies(postId, commentId),
        options: _headers,
      );
      final data = _normalizeData(response.data);
      if (data is List) {
        return data.map((e) => ReplyModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReplyModel> addReply({required int postId, required int commentId, required String text}) async {
    try {
      final response = await _apiClient.post(
        Api.commentReplies(postId, commentId),
        data: {'text': text},
        options: _headers,
      );
      final data = _normalizeData(response.data);
      return ReplyModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReplyModel> updateReply({required int postId, required int commentId, required int replyId, required String text}) async {
    try {
      final response = await _apiClient.put(
        Api.replyById(postId, commentId, replyId),
        data: {'text': text},
        options: _headers,
      );
      final data = _normalizeData(response.data);
      return ReplyModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteReply({required int postId, required int commentId, required int replyId}) async {
    try {
      final response = await _apiClient.delete(
        Api.replyById(postId, commentId, replyId),
        options: _headers,
      );
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e.response?.data));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}

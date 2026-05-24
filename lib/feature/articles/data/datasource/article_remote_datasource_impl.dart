import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/articles/data/datasource/article_remote_datasource_contract.dart';
import 'package:new_mama/feature/articles/data/models/article_category_model.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/data/models/article_search_result_model.dart';

@LazySingleton(as: ArticleRemoteDataSourceContract)
class ArticleRemoteDatasourceImpl implements ArticleRemoteDataSourceContract {
  final ApiClient _apiClient;
  ArticleRemoteDatasourceImpl(this._apiClient);
  Options get _headers => Options(
        headers: {'Accept-Language': getIt<LanguageCubit>().state.languageCode},
      );
  dynamic _normalizeData(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      try {
        return jsonDecode(data);
      } catch (_) {}
    }
    return data;
  }

  @override
  Future<List<ArticleCategoryModel>> getCategories() async {
    final response =
        await _apiClient.get(Api.articleCategories, options: _headers);
    final data = _normalizeData(response.data);
    dynamic parsedData = data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      parsedData = data['data'];
    }

    if (parsedData is! List) {
      throw ServerException(
          'Invalid API response format: expected a List but got ${parsedData.runtimeType}. Raw: $data');
    }

    return parsedData
        .map((json) => ArticleCategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(int categoryId) async {
    final response = await _apiClient.get(
      Api.articles.replaceAll('{categoryId}', categoryId.toString()),
      options: _headers,
    );
    final data = _normalizeData(response.data);
    dynamic parsedData = data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      parsedData = data['data'];
    }

    if (parsedData is! List) {
      throw ServerException(
          'Invalid API response format: expected a List but got ${parsedData.runtimeType}. Raw: $data');
    }

    return parsedData
        .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ArticleModel> getArticleById(int id) async {
    final response = await _apiClient.get(
      Api.articleDetail.replaceAll('{id}', id.toString()),
      options: _headers,
    );
    final data = _normalizeData(response.data);
    dynamic parsedData = data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      parsedData = data['data'];
    }

    if (parsedData is! Map<String, dynamic>) {
      throw ServerException(
          'Invalid API response format: expected a Map but got ${parsedData.runtimeType}. Raw: $data');
    }

    return ArticleModel.fromJson(parsedData);
  }

  @override
  Future<ArticleSearchResultModel> searchArticles(String query) async {
    final response = await _apiClient.get(
      Api.articleSearch,
      queryParameters: {'query': query},
      options: _headers,
    );
    final data = _normalizeData(response.data);

    if (data is! Map<String, dynamic>) {
      throw ServerException(
          'Invalid API response format: expected a Map but got ${data.runtimeType}. Raw: $data');
    }

    return ArticleSearchResultModel.fromJson(data);
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    final response = await _apiClient.get(Api.savedArticles, options: _headers);
    final data = _normalizeData(response.data);
    dynamic parsedData = data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      parsedData = data['data'];
    }

    if (parsedData is! List) {
      throw ServerException(
          'Invalid API response format: expected a List but got ${parsedData.runtimeType}. Raw: $data');
    }

    return parsedData
        .map((json) =>
            ArticleModel.fromJson(json as Map<String, dynamic>).copyWith(isSaved: true))
        .toList();
  }

  @override
  Future<void> saveArticle(int articleId) async {
    await _apiClient.post(
      Api.savedArticles,
      data: {'articleId': articleId},
      options: _headers,
    );
  }

  @override
  Future<void> unsaveArticle(int articleId) async {
    await _apiClient.delete(
      Api.deleteSavedArticle(articleId),
      options: _headers,
    );
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final response = await _apiClient.get(Api.searchHistory, options: _headers);
    final data = _normalizeData(response.data);
    dynamic parsedData = data;
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      parsedData = data['data'];
    }

    if (parsedData is! List) {
      return [];
    }

    return parsedData
        .map((json) => (json as Map<String, dynamic>)['searchTerm'] as String)
        .toList();
  }

  @override
  Future<void> clearSearchHistory() async {
    await _apiClient.delete(Api.searchHistory, options: _headers);
  }

  @override
  Future<void> removeSearchTerm(String term) async {
    await _apiClient.delete(Api.deleteSearchTerm(term), options: _headers);
  }
}
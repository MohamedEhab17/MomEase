import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/articles/data/datasource/article_remote_datasource_contract.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/domain/entities/article_category.dart';
import 'package:new_mama/feature/articles/domain/entities/article_search_result.dart';
import 'package:new_mama/feature/articles/domain/repositories/articles_repository.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/network/network_info.dart';

@LazySingleton(as: ArticlesRepository)
class ArticleRepositoryImpl implements ArticlesRepository {
  final ArticleRemoteDataSourceContract _remoteDataSource;
  final NetworkInfo _networkInfo;

  final StreamController<(int, bool)> _articleSaveStatusController = StreamController<(int, bool)>.broadcast();

  ArticleRepositoryImpl(
      this._remoteDataSource, this._networkInfo);

  @override
  Stream<(int, bool)> get articleSaveStatusStream => _articleSaveStatusController.stream;

  @override
  Future<Either<Failure, List<ArticleCategory>>> getCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getCategories();
        final categories = models.map((e) => e.toEntity()).toList();
        return Right(categories);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByCategory(
      int categoryId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models =
            await _remoteDataSource.getArticlesByCategory(categoryId);
        final articles = models.map((e) => e.toEntity()).toList();
        return Right(articles);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, Article>> getArticleById(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getArticleById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> saveArticle(int articleId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.saveArticle(articleId);
        _articleSaveStatusController.add((articleId, true));
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> unsaveArticle(int articleId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.unsaveArticle(articleId);
        _articleSaveStatusController.add((articleId, false));
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getSavedArticles() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getSavedArticles();
        final articles = models.map((e) => e.toEntity()).toList();
        return Right(articles);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, ArticleSearchResult>> searchArticles(
      String query) async {
    if (await _networkInfo.isConnected) {
      try {
        final resultModel = await _remoteDataSource.searchArticles(query);
        return Right(resultModel);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchHistory() async {
    if (await _networkInfo.isConnected) {
      try {
        final history = await _remoteDataSource.getSearchHistory();
        return Right(history);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    // Backend likely handles saving history during search
    // But we keep the method for interface compatibility
    // if needed in the future
  }

  @override
  Future<void> clearSearchHistory() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.clearSearchHistory();
      } catch (_) {}
    }
  }

  @override
  Future<void> removeSearchTerm(String term) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.removeSearchTerm(term);
      } catch (_) {}
    }
  }
}

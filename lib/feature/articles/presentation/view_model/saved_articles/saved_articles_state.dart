import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';

abstract class SavedArticlesState extends Equatable {
  const SavedArticlesState();
  @override
  List<Object?> get props => [];
}

class SavedArticlesInitial extends SavedArticlesState {}

class SavedArticlesLoading extends SavedArticlesState {}

class SavedArticlesSuccess extends SavedArticlesState {
  final List<Article> articles;
  const SavedArticlesSuccess(this.articles);
  @override
  List<Object?> get props => [articles];
}

class SavedArticlesFailure extends SavedArticlesState {
  final String message;
  const SavedArticlesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ToggleSaveLoading extends SavedArticlesState {
  final int articleId;
  const ToggleSaveLoading(this.articleId);
  @override
  List<Object?> get props => [articleId];
}

import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';

abstract class HomeArticlesState extends Equatable {
  const HomeArticlesState();
  @override
  List<Object?> get props => [];
}

class HomeArticlesInitial extends HomeArticlesState {}

class HomeArticlesLoading extends HomeArticlesState {}

class HomeArticlesSuccess extends HomeArticlesState {
  final List<Article> articles;
  final String categoryName;
  const HomeArticlesSuccess(this.articles, this.categoryName);
  @override
  List<Object?> get props => [articles, categoryName];
}

class HomeArticlesFailure extends HomeArticlesState {
  final String message;
  const HomeArticlesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

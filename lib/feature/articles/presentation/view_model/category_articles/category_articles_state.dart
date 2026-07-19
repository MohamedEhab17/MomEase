import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';

abstract class CategoryArticlesState extends Equatable {
  const CategoryArticlesState();
  @override
  List<Object?> get props => [];
}

class CategoryArticlesInitial extends CategoryArticlesState {}

class CategoryArticlesLoading extends CategoryArticlesState {}

class CategoryArticlesSuccess extends CategoryArticlesState {
  final List<Article> articles;
  const CategoryArticlesSuccess(this.articles);
  @override
  List<Object?> get props => [articles];
}

class CategoryArticlesFailure extends CategoryArticlesState {
  final String message;
  const CategoryArticlesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

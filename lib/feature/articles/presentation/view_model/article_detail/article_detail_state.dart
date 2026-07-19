import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';

abstract class ArticleDetailState extends Equatable {
  const ArticleDetailState();
  @override
  List<Object?> get props => [];
}

class ArticleDetailInitial extends ArticleDetailState {}

class ArticleDetailLoading extends ArticleDetailState {}

class ArticleDetailSuccess extends ArticleDetailState {
  final Article article;
  const ArticleDetailSuccess(this.article);
  @override
  List<Object?> get props => [article];
}

class ArticleDetailFailure extends ArticleDetailState {
  final String message;
  const ArticleDetailFailure(this.message);
  @override
  List<Object?> get props => [message];
}

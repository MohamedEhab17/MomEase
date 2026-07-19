import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/articles/domain/entities/article_search_result.dart';

abstract class SearchArticlesState extends Equatable {
  const SearchArticlesState();

  @override
  List<Object?> get props => [];
}

class SearchArticlesInitial extends SearchArticlesState {}

class SearchArticlesLoading extends SearchArticlesState {}

class SearchArticlesSuccess extends SearchArticlesState {
  final ArticleSearchResult result;

  const SearchArticlesSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchArticlesHistory extends SearchArticlesState {
  final List<String> history;

  const SearchArticlesHistory(this.history);

  @override
  List<Object?> get props => [history];
}

class SearchArticlesFailure extends SearchArticlesState {
  final String message;

  const SearchArticlesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

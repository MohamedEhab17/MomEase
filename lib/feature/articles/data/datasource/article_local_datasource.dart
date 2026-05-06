import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticleLocalDataSource {
  // Future<List<Article>> getArticles();
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}

@LazySingleton(as: ArticleLocalDataSource)
class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _searchHistoryKey = 'articles_search_history';

  ArticleLocalDataSourceImpl(this._sharedPreferences);

  // @override
  // Future<List<Article>> getArticles() async {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   return dummyArticles;
  // }

  @override
  Future<List<String>> getSearchHistory() async {
    final history = _sharedPreferences.getStringList(_searchHistoryKey) ?? [];
    return history;
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    
    final history = _sharedPreferences.getStringList(_searchHistoryKey) ?? [];
    
    // Remove if already exists to move it to the top
    history.remove(query);
    
    // Insert at the beginning
    history.insert(0, query);
    
    // Keep only last 10
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    
    await _sharedPreferences.setStringList(_searchHistoryKey, history);
  }

  @override
  Future<void> clearSearchHistory() async {
    await _sharedPreferences.remove(_searchHistoryKey);
  }
}

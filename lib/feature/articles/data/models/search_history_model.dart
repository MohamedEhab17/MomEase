class SearchHistoryModel {
  final int searchId;
  final String searchTerm;
  final DateTime searchedAt;

  SearchHistoryModel({
    required this.searchId,
    required this.searchTerm,
    required this.searchedAt,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      searchId: json['searchId'] ?? 0,
      searchTerm: json['searchTerm'] ?? '',
      searchedAt: DateTime.parse(json['searchedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchId': searchId,
      'searchTerm': searchTerm,
      'searchedAt': searchedAt.toIso8601String(),
    };
  }
}

abstract class AppSectionLocalDatasourceContract {
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
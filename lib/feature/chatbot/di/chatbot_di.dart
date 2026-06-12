import '../data/datasources/chatbot_remote_data_source.dart';
import '../data/repositories/chatbot_repository.dart';
import '../presentation/cubit/chatbot_cubit.dart';

/// Dependency injection setup for chatbot feature
/// Provides factory methods for creating chatbot components
class ChatbotDI {
  /// Creates a ChatbotRemoteDataSource instance
  static ChatbotRemoteDataSource createDataSource({
    String? apiKey,
    String? systemInstruction,
  }) {
    return ChatbotRemoteDataSourceImpl(
      apiKey: apiKey,
      systemInstruction: systemInstruction,
    );
  }

  /// Creates a ChatbotRepository instance
  static ChatbotRepository createRepository({
    ChatbotRemoteDataSource? dataSource,
  }) {
    return ChatbotRepositoryImpl(
      dataSource ?? createDataSource(),
    );
  }

  /// Creates a ChatbotCubit instance
  static ChatbotCubit createCubit({
    ChatbotRepository? repository,
  }) {
    return ChatbotCubit(
      repository ?? createRepository(),
    );
  }
}

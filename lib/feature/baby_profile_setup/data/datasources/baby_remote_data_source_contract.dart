
abstract class BabyRemoteDataSourceContract {
  Future<void> createBaby(
    final String name,
    final String gender,
    final String deliveryType,
    final String feedingType,
    final String dateOfBirth,
  );
}

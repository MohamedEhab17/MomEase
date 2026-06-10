import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class GetGrowthChartDataUseCase {
  final GrowthRepository repository;

  GetGrowthChartDataUseCase(this.repository);

  Future<Either<Failure, GrowthChartDataEntity>> call(int childId) {
    return repository.getGrowthChartData(childId);
  }
}

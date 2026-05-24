import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';

abstract class BabyProfileRepository {
  Future<Either<Failure, void>> saveBabyProfile({required String babyName});
}
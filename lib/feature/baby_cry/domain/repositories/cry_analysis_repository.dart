import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import '../entities/cry_analysis.dart';

abstract class CryAnalysisRepository {
  Future<Either<Failure, CryAnalysis>> analyzeCry({
    required File audioFile,
    required int childId,
  });

  Future<Either<Failure, List<CryAnalysis>>> getUserCryAnalyses();

  Future<Either<Failure, List<CryAnalysis>>> getChildCryAnalyses(int childId);

  Future<Either<Failure, void>> deleteCryAnalysis(int cryId);
}

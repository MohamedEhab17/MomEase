import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../entities/cry_analysis.dart';
import '../repositories/cry_analysis_repository.dart';

class AnalyzeCryParams {
  final File audioFile;
  final int childId;

  const AnalyzeCryParams({required this.audioFile, required this.childId});
}

@injectable
class AnalyzeCryUseCase {
  final CryAnalysisRepository _repository;

  AnalyzeCryUseCase(this._repository);

  Future<Either<Failure, CryAnalysis>> call(AnalyzeCryParams params) {
    return _repository.analyzeCry(
      audioFile: params.audioFile,
      childId: params.childId,
    );
  }
}

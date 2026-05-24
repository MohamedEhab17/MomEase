import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';

enum SkinDiagnosisStatus {
  initial,
  loading,
  imageSelected,
  analyzing,
  success,
  historyLoading,
  historySuccess,
  deleting,
  error,
}

class SkinDiagnosisState {
  final SkinDiagnosisStatus status;
  final File? selectedImage;
  final String? errorMessage;
  final ImageSource? imageSource;

  /// Result from the latest analysis call
  final SkinAnalysis? analysisResult;

  /// History list (all user analyses or child-specific)
  final List<SkinAnalysis> historyList;

  const SkinDiagnosisState({
    this.status = SkinDiagnosisStatus.initial,
    this.selectedImage,
    this.errorMessage,
    this.imageSource,
    this.analysisResult,
    this.historyList = const [],
  });

  SkinDiagnosisState copyWith({
    SkinDiagnosisStatus? status,
    File? selectedImage,
    bool clearSelectedImage = false,
    String? errorMessage,
    bool clearError = false,
    ImageSource? imageSource,
    SkinAnalysis? analysisResult,
    List<SkinAnalysis>? historyList,
  }) {
    return SkinDiagnosisState(
      status: status ?? this.status,
      selectedImage:
          clearSelectedImage ? null : selectedImage ?? this.selectedImage,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
      imageSource: imageSource ?? this.imageSource,
      analysisResult: analysisResult ?? this.analysisResult,
      historyList: historyList ?? this.historyList,
    );
  }
}

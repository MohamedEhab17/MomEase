import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum SkinDiagnosisStatus { initial, loading, imageSelected, error }

class SkinDiagnosisState {
  final SkinDiagnosisStatus status;
  final File? selectedImage;
  final String? errorMessage;
  final ImageSource? imageSource;

  const SkinDiagnosisState({
    this.status = SkinDiagnosisStatus.initial,
    this.selectedImage,
    this.errorMessage,
    this.imageSource,
  });

  SkinDiagnosisState copyWith({
    SkinDiagnosisStatus? status,
    File? selectedImage,
    String? errorMessage,
    ImageSource? imageSource,
  }) {
    return SkinDiagnosisState(
      status: status ?? this.status,
      selectedImage: selectedImage ?? this.selectedImage,
      errorMessage: errorMessage ?? this.errorMessage,
      imageSource: imageSource ?? this.imageSource,
    );
  }
}

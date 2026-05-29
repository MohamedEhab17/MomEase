import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/usecases/analyze_skin_image_usecase.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/usecases/delete_skin_analysis_usecase.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/usecases/get_child_skin_analyses_usecase.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/usecases/get_user_skin_analyses_usecase.dart';
import 'skin_diagnosis_state.dart';

@injectable
class SkinDiagnosisCubit extends SafeCubit<SkinDiagnosisState> {
  final AnalyzeSkinImageUseCase _analyzeUseCase;
  final GetUserSkinAnalysesUseCase _getUserAnalysesUseCase;
  final GetChildSkinAnalysesUseCase _getChildAnalysesUseCase;
  final DeleteSkinAnalysisUseCase _deleteUseCase;

  SkinDiagnosisCubit(
    this._analyzeUseCase,
    this._getUserAnalysesUseCase,
    this._getChildAnalysesUseCase,
    this._deleteUseCase,
  ) : super(const SkinDiagnosisState());

  final ImagePicker _picker = ImagePicker();

  // ── Image Picking ───────────────────────────────────────────────────────────

  Future<void> pickImage(ImageSource source) async {
    try {
      safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.loading,
        clearError: true,
      ));

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        // Copy to a stable temp path to avoid "path not found" on camera images
        final tempDir = await getTemporaryDirectory();
        final fileName = 'skin_${DateTime.now().millisecondsSinceEpoch}${p.extension(image.path)}';
        final stableFile = await File(image.path).copy('${tempDir.path}/$fileName');

        safeEmit(state.copyWith(
          status: SkinDiagnosisStatus.imageSelected,
          selectedImage: stableFile,
          imageSource: source,
          clearError: true,
        ));
      } else {
        safeEmit(state.copyWith(
          status: state.selectedImage != null
              ? SkinDiagnosisStatus.imageSelected
              : SkinDiagnosisStatus.initial,
        ));
      }
    } catch (e) {
      safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.error,
        errorMessage: 'Failed to pick image: ${e.toString()}',
      ));
    }
  }

  Future<void> cropImage({
    required Color primaryColor,
    required Color surfaceColor,
  }) async {
    if (state.selectedImage == null) return;
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: state.selectedImage!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: primaryColor,
            toolbarWidgetColor: surfaceColor,
            activeControlsWidgetColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Photo'),
        ],
      );

      if (croppedFile != null) {
        // Copy to stable path to avoid path not found on some devices
        final tempDir = await getTemporaryDirectory();
        final fileName = 'skin_crop_${DateTime.now().millisecondsSinceEpoch}${p.extension(croppedFile.path)}';
        final stableFile = await File(croppedFile.path).copy('${tempDir.path}/$fileName');
        safeEmit(state.copyWith(selectedImage: stableFile));
      }
    } catch (e) {
      safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.error,
        errorMessage: 'Failed to crop image: ${e.toString()}',
      ));
    }
  }

  void clearImage() {
    safeEmit(const SkinDiagnosisState());
  }

  // ── API Operations ──────────────────────────────────────────────────────────

  Future<void> analyzeImage({required int childId}) async {
    if (state.selectedImage == null) return;

    safeEmit(state.copyWith(
      status: SkinDiagnosisStatus.analyzing,
      clearError: true,
    ));

    final result = await _analyzeUseCase(AnalyzeImageParams(
      image: state.selectedImage!,
      childId: childId,
    ));

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.error,
        errorMessage: failure.message,
      )),
      (analysis) => safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.success,
        analysisResult: analysis,
      )),
    );
  }

  Future<void> loadUserHistory() async {
    safeEmit(state.copyWith(
      status: SkinDiagnosisStatus.historyLoading,
      clearError: true,
    ));

    final result = await _getUserAnalysesUseCase();

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.error,
        errorMessage: failure.message,
      )),
      (list) => safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.historySuccess,
        historyList: list,
      )),
    );
  }

  Future<void> loadChildHistory(int childId) async {
    safeEmit(state.copyWith(
      status: SkinDiagnosisStatus.historyLoading,
      clearError: true,
    ));

    final result = await _getChildAnalysesUseCase(childId);

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.error,
        errorMessage: failure.message,
      )),
      (list) => safeEmit(state.copyWith(
        status: SkinDiagnosisStatus.historySuccess,
        historyList: list,
      )),
    );
  }

  Future<void> deleteAnalysis(int analysisId) async {
    // Optimistic deletion
    final originalList = state.historyList;
    final updatedList = originalList.where((a) => a.skinAnalysisId != analysisId).toList();

    safeEmit(state.copyWith(
      status: SkinDiagnosisStatus.historySuccess,
      historyList: updatedList,
      clearError: true,
    ));

    final result = await _deleteUseCase(analysisId);

    result.fold(
      (failure) {
        // Revert back on error and emit error state
        safeEmit(state.copyWith(
          status: SkinDiagnosisStatus.error,
          errorMessage: failure.message,
          historyList: originalList,
        ));
        // Ensure status goes back to success to display the original list
        safeEmit(state.copyWith(
          status: SkinDiagnosisStatus.historySuccess,
          historyList: originalList,
        ));
      },
      (_) {
        // Success: already handled optimistically
      },
    );
  }
}

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'skin_diagnosis_state.dart';

class SkinDiagnosisCubit extends Cubit<SkinDiagnosisState> {
  SkinDiagnosisCubit() : super(const SkinDiagnosisState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      // Show loading to prevent UI freeze and give feedback during pick/crop
      emit(
        state.copyWith(status: SkinDiagnosisStatus.loading, errorMessage: null),
      );

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        emit(
          state.copyWith(
            status: SkinDiagnosisStatus.imageSelected,
            selectedImage: File(image.path),
            imageSource: source,
            errorMessage: null,
          ),
        );
      } else {
        // User cancelled image picker
        emit(
          state.copyWith(
            status: state.selectedImage != null
                ? SkinDiagnosisStatus.imageSelected
                : SkinDiagnosisStatus.initial,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SkinDiagnosisStatus.error,
          errorMessage: 'Failed to pick image: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> cropImage() async {
    if (state.selectedImage == null) return;
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: state.selectedImage!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: AppColors.primaryDark,
            toolbarWidgetColor: AppColors.lightBackground,
            activeControlsWidgetColor: AppColors.primaryDark,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Photo'),
        ],
      );

      if (croppedFile != null) {
        emit(state.copyWith(selectedImage: File(croppedFile.path)));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SkinDiagnosisStatus.error,
          errorMessage: 'Failed to crop image: ${e.toString()}',
        ),
      );
    }
  }

  void clearImage() {
    emit(const SkinDiagnosisState());
  }
}

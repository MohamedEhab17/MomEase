import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_state.dart';

class SkinDiagnosisActions extends StatelessWidget {
  const SkinDiagnosisActions({super.key, required this.state});
  final SkinDiagnosisState state;

  @override
  Widget build(BuildContext context) {
    if (state.selectedImage != null) {
      return Column(
        children: [
          CustomElevatedButton(
            text: 'Analyze Skin',
            icon: Icon(
              Icons.analytics_outlined,
              color: AppColors.lightBackground,
              size: 24.w,
            ),
            onPressed: () {
              context.push(AppRoutesPaths.skinDiagnosisAnalyzingView);
            },
            backgroundColor: AppColors.primaryDark,
            minimumSize: Size(double.infinity, 52.h),
            textStyle: AppStyles.styleInter20.copyWith(
              color: AppColors.lightBackground,
            ),
          ),
          if (state.imageSource != ImageSource.gallery) ...[
            16.height,
            CustomElevatedButton(
              text: 'Retake Photo',
              icon: SvgPicture.asset(
                AppIcons.iconsCamera,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryDark,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: state.status == SkinDiagnosisStatus.loading
                  ? () {}
                  : () {
                      context.read<SkinDiagnosisCubit>().pickImage(
                        ImageSource.camera,
                      );
                    },
              borderColor: AppColors.primaryDark,
              backgroundColor: AppColors.lightBackground,
              minimumSize: Size(double.infinity, 52.h),
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
          if (state.imageSource != ImageSource.camera) ...[
            16.height,
            CustomElevatedButton(
              text: 'Reupload From Gallery',
              icon: SvgPicture.asset(
                AppIcons.iconsUpload,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryDark,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: state.status == SkinDiagnosisStatus.loading
                  ? () {}
                  : () {
                      context.read<SkinDiagnosisCubit>().pickImage(
                        ImageSource.gallery,
                      );
                    },
              borderColor: AppColors.primaryDark,
              backgroundColor: AppColors.lightBackground,
              minimumSize: Size(double.infinity, 52.h),
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ],
      );
    }

    // No selected image yet
    return Column(
      children: [
        CustomElevatedButton(
          text: 'Take Photo',
          icon: SvgPicture.asset(
            AppIcons.iconsCamera,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              AppColors.lightBackground,
              BlendMode.srcIn,
            ),
          ),
          onPressed: state.status == SkinDiagnosisStatus.loading
              ? () {}
              : () {
                  context.read<SkinDiagnosisCubit>().pickImage(
                    ImageSource.camera,
                  );
                },
          backgroundColor: AppColors.primaryDark,
          minimumSize: Size(double.infinity, 52.h),
          textStyle: AppStyles.styleInter20.copyWith(
            color: AppColors.lightBackground,
          ),
        ),
        24.height,
        CustomElevatedButton(
          text: 'Upload From Gallery',
          icon: SvgPicture.asset(
            AppIcons.iconsUpload,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryDark,
              BlendMode.srcIn,
            ),
          ),
          onPressed: state.status == SkinDiagnosisStatus.loading
              ? () {}
              : () {
                  context.read<SkinDiagnosisCubit>().pickImage(
                    ImageSource.gallery,
                  );
                },
          borderColor: AppColors.primaryDark,
          backgroundColor: AppColors.lightBackground,
          minimumSize: Size(double.infinity, 52.h),
          textStyle: AppStyles.styleInter20.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

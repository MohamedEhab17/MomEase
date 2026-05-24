import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
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
            text: context.trContext(TK.skinAnalyzeSkin),
            icon: Icon(
              Icons.analytics_outlined,
              color: context.theme.buttonTheme.colorScheme!.onPrimary,
              size: 24.w,
            ),
            onPressed: () {
              context.push(AppRoutesPaths.skinDiagnosisAnalyzingView);
            },
            minimumSize: Size(double.infinity, 52.h),
          ),
          16.height,

          if (state.imageSource != ImageSource.gallery) ...[
            16.height,
            CustomElevatedButton(
              text: context.trContext(TK.skinRetakePhoto),
              icon: SvgPicture.asset(
                AppIcons.iconsCamera,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  context.ext.colors.primaryDark,
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
              borderColor: context.theme.buttonTheme.colorScheme!.primary,
              backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
              minimumSize: Size(double.infinity, 52.h),
              textStyle: context.text.headlineMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.primary,
              ),
            ),
          ],
          if (state.imageSource != ImageSource.camera) ...[
            16.height,
            CustomElevatedButton(
              text: context.trContext(TK.skinReuploadGallery),
              icon: SvgPicture.asset(
                AppIcons.iconsUpload,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  context.ext.colors.primaryDark,
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
              borderColor: context.theme.buttonTheme.colorScheme!.primary,
              backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
              minimumSize: Size(double.infinity, 52.h),
              textStyle: context.text.headlineMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.primary,
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
          text: context.trContext(TK.skinTakePhoto),
          icon: SvgPicture.asset(
            AppIcons.iconsCamera,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(
              context.theme.buttonTheme.colorScheme!.onPrimary,
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
          minimumSize: Size(double.infinity, 52.h),
        ),
        24.height,
        CustomElevatedButton(
          text: context.trContext(TK.skinUploadGallery),
          icon: SvgPicture.asset(
            AppIcons.iconsUpload,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(
              context.ext.colors.primaryDark,
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
          borderColor: context.ext.colors.primaryDark,
          backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
          minimumSize: Size(double.infinity, 52.h),
          textStyle: context.text.headlineMedium!.copyWith(
            color: context.theme.buttonTheme.colorScheme!.primary,
          ),
        ),
      ],
    );
  }
}

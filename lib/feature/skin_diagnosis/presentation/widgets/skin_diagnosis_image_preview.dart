import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/animated_dotted_container.dart';
import 'package:new_mama/core/widgets/full_screen_local_gallery.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_state.dart';

class SkinDiagnosisImagePreview extends StatelessWidget {
  const SkinDiagnosisImagePreview({super.key, required this.state});
  final SkinDiagnosisState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedDottedContainer(
      color: context.colors.primary,
      dashPattern: const [8, 6],
      borderRadius: BorderRadius.circular(16),
      strokeWidth: 3.w,
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.4,
        child: state.status == SkinDiagnosisStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : state.selectedImage != null
            ? Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenLocalGallery(
                            images: [state.selectedImage!],
                            initialIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.file(
                          state.selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 12.h,
                    end: 12.w,
                    child: InkWell(
                      onTap: () {
                        context.read<SkinDiagnosisCubit>().cropImage(
                          primaryColor: context.ext.colors.primaryDark,
                          surfaceColor: context.colors.surface,
                        );
                      },
                      child: Container(
                        padding: 8.w.allPadding,
                        decoration: BoxDecoration(
                          color: context.colors.surface.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.crop,
                          color: context.ext.colors.primaryDark,
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: context.ext.colors.primaryDark.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 48.w,
                      color: context.ext.colors.primaryDark,
                    ),
                  ),
                  24.height,
                  Text(
                    context.trContext(TK.skinNoPhotoTitle),
                    style: context.text.headlineMedium!.copyWith(
                      color: context.ext.colors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.height,
                  Text(
                    context.trContext(TK.skinNoPhotoSubtitle),
                    textAlign: TextAlign.center,
                    style: context.text.titleLarge!.copyWith(
                      color: context.ext.colors.primaryDark.withAlpha(128),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
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
      color: AppColors.primary,
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
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: InkWell(
                      onTap: () {
                        context.read<SkinDiagnosisCubit>().cropImage();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.crop,
                          color: AppColors.primaryHard,
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
                      color: AppColors.primaryHard.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 48.w,
                      color: AppColors.primaryHard,
                    ),
                  ),
                  24.height,
                  Text(
                    'No Photo Selected',
                    style: AppStyles.styleInter20.copyWith(
                      color: AppColors.primaryHard,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.height,
                  Text(
                    'Please take a clear photo or upload\none from your gallery.',
                    textAlign: TextAlign.center,
                    style: AppStyles.styleInter16.copyWith(
                      color: AppColors.primaryHard.withAlpha(128),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart';

class CryRecordingView extends StatelessWidget {
  const CryRecordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        CircleAvatar(
          radius: 50.r,
          backgroundColor: AppColors.primarySoft,
          child: Image.asset(
            AppImages.imagesRecord,
            height: 64.h,
            width: 53.w,
            fit: BoxFit.contain,
          ),
        ),
        24.h.height,
        BlocBuilder<SoundRecordingCubit, SoundRecordingState>(
          builder: (context, state) {
          if (state is  RecordingInProgress) {
      return Text(
        '${state.seconds}s',
        style: AppStyles.styleInter24,
      );
    }
    return Text(
      '0s',
      style: AppStyles.styleInter24,
    );
  
          },
        ),
        10.h.height,
        Text(
          'Recording baby’s cry...',
          style: AppStyles.styleInter16.copyWith(
            color: AppColors.darkBackground.withAlpha(76),
          ),
        ),
        96.h.height,

        CustomElevatedButton(
          text: 'Stop Recording',
          onPressed: () {
            context.read<SoundRecordingCubit>().stopRecording();
          },
          borderColor: AppColors.primaryHard,
          backgroundColor: AppColors.lightBackground,
          minimumSize: Size(double.infinity, 52.h),
          textStyle: AppStyles.styleInter20.copyWith(
            color: AppColors.primaryHard,
          ),
        ),
        Spacer(),
      ],
    );
  }
}

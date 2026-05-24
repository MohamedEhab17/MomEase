import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_images.dart';
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
          backgroundColor: context.ext.colors.primaryLighter,
          child: Image.asset(
            AppImages.imagesRecord,
            height: 64.h,
            width: 64.w,
            fit: BoxFit.contain,
            color: context.ext.colors.primaryDark,
          ),
        ),
        24.h.height,
        BlocBuilder<SoundRecordingCubit, SoundRecordingState>(
          builder: (context, state) {
            if (state is RecordingInProgress) {
              return Text(
                '${state.seconds}s',
                style: context.text.displaySmall!,
              );
            }
            return Text('0s', style: context.text.displaySmall!);
          },
        ),
        10.h.height,
        Text(
          context.trContext(TK.babyCryRecordingStatus),
          style: context.text.titleMedium!.copyWith(
            color: context.text.titleMedium!.color!.withAlpha(178),
          ),
        ),
        96.h.height,

        CustomElevatedButton(
          text: context.trContext(TK.babyCryStopRecording),
          onPressed: () {
            context.read<SoundRecordingCubit>().stopRecording();
          },
          borderColor: context.theme.buttonTheme.colorScheme!.primary,
          backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
          minimumSize: Size(double.infinity, 52.h),
          textStyle: context.text.headlineMedium!.copyWith(
            color: context.theme.buttonTheme.colorScheme!.primary,
          ),
          elevation: 5,
        ),
        Spacer(),
      ],
    );
  }
}

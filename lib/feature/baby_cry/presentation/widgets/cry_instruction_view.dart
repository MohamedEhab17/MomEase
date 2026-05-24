import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/custom_circle_avatar_with_shadow.dart';

class CryInstructionView extends StatelessWidget {
  const CryInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: .center,
        children: [
          Spacer(),
          Text(
            context.trContext(TK.babyCryHoldPhoneNear),
            style: context.text.displayMedium!,
          ),
          10.h.height,
          Text(
            context.trContext(TK.babyCryTapToStart),
            style: context.text.titleMedium!.copyWith(
              color: context.text.titleMedium!.color!.withAlpha(178),
            ),
          ),
          83.h.height,
          CustomCircleAvatarWithShadow(
            onTap: () {
              context.read<SoundRecordingCubit>().startRecording();
            },
          ),
          40.h.height,
          Text(
            context.trContext(TK.babyCryTipQuietPlace),
            style: context.text.titleMedium!.copyWith(
              color: context.text.titleMedium!.color!.withAlpha(178),
            ),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

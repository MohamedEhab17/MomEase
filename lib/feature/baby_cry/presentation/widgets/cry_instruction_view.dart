import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/custom_circle_avatar_with_shadow.dart';

class CryInstructionView extends StatelessWidget {
  const CryInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text('Hold Phone Near Baby', style: context.text.displayMedium!),
        10.h.height,
        Text(
          'Tap the button to start recording',
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
          'Tip: Be in a quite place while you are recording',
          style: context.text.titleMedium!.copyWith(
            color: context.text.titleMedium!.color!.withAlpha(178),
          ),
          softWrap: true,
          textAlign: .center,
        ),
        Spacer(),
      ],
    );
  }
}

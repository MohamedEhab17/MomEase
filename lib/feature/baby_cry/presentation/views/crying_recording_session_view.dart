import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/cry_instruction_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/cry_recording_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/crying_result_view.dart';
import 'package:open_file/open_file.dart';


class CryingRecordingSessionView extends StatelessWidget {
   CryingRecordingSessionView({super.key});
  final List<String> advices = [
    'Take small moments for yourself, even 5 minutes of quiet time.',
    'Connect with loved ones or join a mother\'s support group.',
    'If you\'re concerned, reach out to your healthcare provider.',
    'Remember: asking for help is a sign of strength, not weakness.',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SoundRecordingCubit>(),
      child: Scaffold(
        appBar: FeaturesHeader(title: 'Crying Sound analysis'),
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 22.w),
          child: BlocConsumer<SoundRecordingCubit, SoundRecordingState>(
            listener: (context, state) async {
              if (state is RecordingStopped && state.path != null) {
                log("File ready: ${state.path}");
                await OpenFile.open(state.path!);
              } else if (state is RecordingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is RecordingStarted || state is RecordingInProgress) {
                return CryRecordingView();
              }

             else if (state is RecordingStopped) {
                return CryingResultView(advices: advices,);
              }
              return CryInstructionView();
            },
          ),
        ),
      ),
    );
  }
}



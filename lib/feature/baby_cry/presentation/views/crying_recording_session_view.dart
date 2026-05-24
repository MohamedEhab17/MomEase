import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/baby_cry/presentation/view_model/cubit/sound_recording_cubit.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/cry_analyzing_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/cry_instruction_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/widgets/cry_recording_view.dart';
import 'package:open_file/open_file.dart';

class CryingRecordingSessionView extends StatelessWidget {
  const CryingRecordingSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SoundRecordingCubit>(),
      child: Scaffold(
        appBar: FeaturesHeader(title: context.trContext(TK.babyCryAppBarTitle)),
        body: Padding(
          padding: 22.hPadding,
          child: BlocConsumer<SoundRecordingCubit, SoundRecordingState>(
            listener: (context, state) async {
              if (state is RecordingStopped && state.path != null) {
                log("File ready: ${state.path}");
                await OpenFile.open(state.path!);
              } else if (state is RecordingError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is RecordingStarted || state is RecordingInProgress) {
                return CryRecordingView();
              } else if (state is RecordingStopped) {
                return CryAnalyzingView();
              }
              return CryInstructionView();
            },
          ),
        ),
      ),
    );
  }
}

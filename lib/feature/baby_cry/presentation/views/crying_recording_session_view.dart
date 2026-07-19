import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import '../../presentation/view_model/cubit/sound_recording_cubit.dart';
import '../../presentation/view_model/cubit/baby_cry_cubit.dart';
import 'cry_analyzing_view.dart';
import '../widgets/cry_instruction_view.dart';
import '../widgets/cry_recording_view.dart';

class CryingRecordingSessionView extends StatelessWidget {
  const CryingRecordingSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SoundRecordingCubit>(),
      child: Scaffold(
        appBar: FeaturesHeader(
          title: context.trContext(TK.babyCryAppBarTitle),
          trailingAction: const SizedBox.shrink(),
        ),
        body: Padding(
          padding: 22.hPadding,
          child: BlocConsumer<SoundRecordingCubit, SoundRecordingState>(
            listener: (context, state) async {
              if (state is RecordingStopped && state.path != null) {
                log("File ready: ${state.path}");
                final activeChild = context.read<ActiveChildCubit>().state;
                if (activeChild == null) {
                  AppToast.error(
                    context,
                    message: context.trContext(TK.babyCrySelectChild),
                  );
                  return;
                }
                context.read<BabyCryCubit>().analyzeCry(
                      audioFile: File(state.path!),
                      childId: activeChild.childId,
                    );
              } else if (state is RecordingError) {
                AppToast.error(context, message: state.message);
              }
            },
            builder: (context, state) {
              if (state is RecordingStarted || state is RecordingInProgress) {
                return const CryRecordingView();
              } else if (state is RecordingStopped) {
                return const CryAnalyzingView();
              }
              return const CryInstructionView();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/community_components/community_body.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CommunityCubit>()..loadPosts(),
      child: BlocListener<CommunityCubit, CommunityState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null &&
            current.status != CommunityStatus.error,
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppToast.error(
              context,
              message: state.errorMessage!.isNotEmpty
                  ? state.errorMessage!
                  : context.trContext(TK.toastActionFailed),
            );
          }
        },
        child: Padding(
          padding: 20.hPadding,
          child: const CommunityBody(),
        ),
      ),
    );
  }
}

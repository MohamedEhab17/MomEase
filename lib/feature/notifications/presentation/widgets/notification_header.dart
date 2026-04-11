import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import '../view_model/notification_cubit.dart';
import '../view_model/notification_state.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 20.hPadding,
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return Row(
            children: [
              Text('Notifications', style: context.text.displayMedium!),
              const Spacer(),
              TextButton(
                onPressed: state.notifications.isEmpty
                    ? null
                    : () => context.read<NotificationCubit>().clearAll(),
                child: Text(
                  'Clear all',
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: state.notifications.isEmpty
                        ? context.ext.colors.textDisabledLighter
                        : context.ext.colors.primaryDark,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/vaccinations_cubit/vaccinations_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/vaccinations_cubit/vaccinations_state.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_age_group_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_empty_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_loading_skeleton.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_mark_taken_sheet.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_progress_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_record_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_section_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_sub_tab.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';

String _formatMonthDay(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Root widget — provides VaccinationsCubit and listens to child changes
// ─────────────────────────────────────────────────────────────────────────────
class VaccineTabView extends StatelessWidget {
  const VaccineTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final activeChild = context.read<ActiveChildCubit>().state;
        final cubit = getIt<VaccinationsCubit>();
        if (activeChild != null) {
          cubit.fetchAllVaccinationData(activeChild.childId);
        }
        return cubit;
      },
      child: BlocListener<ActiveChildCubit, Child?>(
        listener: (context, activeChild) {
          if (activeChild != null) {
            context.read<VaccinationsCubit>().fetchAllVaccinationData(activeChild.childId);
          }
        },
        child: const _VaccineTabViewContent(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Content — reacts to VaccinationsCubit states
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineTabViewContent extends StatelessWidget {
  const _VaccineTabViewContent();

  @override
  Widget build(BuildContext context) {
    final activeChild = context.watch<ActiveChildCubit>().state;

    // No child selected
    if (activeChild == null) {
      return _VaccineNoChildPlaceholder();
    }

    return BlocConsumer<VaccinationsCubit, VaccinationsState>(
      listener: (context, state) {
        if (state is VaccinationsLoaded) {
          if (state.errorMessage != null) {
            AppToast.error(context, message: state.errorMessage!);
          } else if (state.successMessage != null) {
            AppToast.success(context, message: state.successMessage!);
          }
        }
      },
      builder: (context, state) {
        if (state is VaccinationsLoading || state is VaccinationsInitial) {
          return const VaccineLoadingSkeleton();
        }

        if (state is VaccinationsError) {
          return _VaccineErrorState(
            message: state.message,
            onRetry: () => context
                .read<VaccinationsCubit>()
                .fetchAllVaccinationData(activeChild.childId),
          );
        }

        if (state is VaccinationsLoaded) {
          return _VaccineLoadedBody(
            state: state,
            activeChild: activeChild,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// No child placeholder
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineNoChildPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care_rounded,
              size: 64.sp,
              color: context.ext.colors.primaryLight,
            ),
            16.h.height,
            Text(
              context.trContext(TK.babyVaccineSelectChildMsg),
              textAlign: TextAlign.center,
              style: context.text.bodyLarge!.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _VaccineErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: context.ext.colors.severityHigh,
            ),
            16.h.height,
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge!.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            20.h.height,
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.trContext(TK.commonRetry)),
              style: FilledButton.styleFrom(
                backgroundColor: context.ext.colors.primaryDark,
                foregroundColor: context.ext.colors.primaryExtraLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loaded state — full vaccine UI
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineLoadedBody extends StatelessWidget {
  final VaccinationsLoaded state;
  final Child activeChild;

  const _VaccineLoadedBody({required this.state, required this.activeChild});

  void _openMarkSheet(BuildContext context, VaccineEntity vaccine) {
    VaccineMarkTakenSheet.show(
      context,
      vaccine: vaccine,
      childId: activeChild.childId,
      cubit: context.read<VaccinationsCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups   = state.vaccineGroups;
    final upcoming = state.upcomingVaccines;
    final overdue  = state.overdueVaccines;
    final completed = state.completedVaccines;

    final totalCount     = completed.length + upcoming.length + overdue.length;
    final completedCount = completed.length;

    // Compute next due vaccine
    String nextDueDate = '—';
    int daysUntilDue = 0;
    if (upcoming.isNotEmpty) {
      final sorted = List<VaccineEntity>.from(upcoming)
        ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
      nextDueDate = _formatMonthDay(sorted.first.scheduledDate);
      daysUntilDue = sorted.first.scheduledDate
          .difference(DateTime.now())
          .inDays
          .clamp(0, 9999);
    }

    final babyTrackCubit = context.watch<BabyTrackCubit>();
    final tabIdx = babyTrackCubit.vaccineTabIndex;

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<VaccinationsCubit>().fetchAllVaccinationData(activeChild.childId),
      color: context.ext.colors.primaryDark,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Progress header ───────────────────────────────────────────
            VaccineProgressHeader(
              completed: completedCount,
              total: totalCount == 0 ? 1 : totalCount,
              nextDueDate: nextDueDate,
              daysUntilDue: daysUntilDue,
            ),
            20.h.height,

            // ── Sub-tab bar ───────────────────────────────────────────────
            _VaccineSubTabBar(
              selectedIndex: tabIdx,
              onTabChanged: babyTrackCubit.switchVaccineTab,
            ),
            16.h.height,

            // ── Content based on selected tab ─────────────────────────────
            if (tabIdx == 0)
              _VaccineLogTab(
                overdue: overdue,
                upcoming: upcoming,
                completed: completed,
                updatingVaccineId: state.updatingVaccineId,
                onMarkTaken: (v) => _openMarkSheet(context, v),
              )
            else
              _VaccineScheduleTab(
                groups: groups,
                updatingVaccineId: state.updatingVaccineId,
                childId: activeChild.childId,
                onMarkTaken: (v) => _openMarkSheet(context, v),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-tab bar
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineSubTabBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabChanged;

  const _VaccineSubTabBar({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.ext.colors.primaryTint,
        borderRadius: BorderRadius.circular(64.r),
      ),
      child: Row(
        children: [
          VaccineSubTab(
            label: context.trContext(TK.babyVaccineLog),
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          VaccineSubTab(
            label: context.trContext(TK.babyVaccineSchedule),
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vaccination log tab (overdue / upcoming / completed)
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineLogTab extends StatelessWidget {
  final List<VaccineEntity> overdue;
  final List<VaccineEntity> upcoming;
  final List<VaccineEntity> completed;
  final int? updatingVaccineId;
  final void Function(VaccineEntity) onMarkTaken;

  const _VaccineLogTab({
    required this.overdue,
    required this.upcoming,
    required this.completed,
    required this.updatingVaccineId,
    required this.onMarkTaken,
  });

  @override
  Widget build(BuildContext context) {
    if (overdue.isEmpty && upcoming.isEmpty && completed.isEmpty) {
      return VaccineEmptyCard(
        message: context.trContext(TK.babyVaccineNoLoggedVaccines),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overdue
        if (overdue.isNotEmpty) ...[
          VaccineSectionHeader(
            title: context.trContext(TK.babyVaccineOverdueMissed),
            count: overdue.length,
            color: context.ext.colors.severityHigh,
          ),
          12.h.height,
          ...overdue.map(
            (v) => VaccineRecordCard(
              key: ValueKey('overdue_${v.childVaccineId}'),
              vaccine: v,
              isUpdating: updatingVaccineId == v.childVaccineId,
              onMarkTaken: () => onMarkTaken(v),
            ),
          ),
          16.h.height,
        ],

        // Upcoming
        if (upcoming.isNotEmpty) ...[
          VaccineSectionHeader(
            title: context.trContext(TK.babyVaccineUpcoming),
            count: upcoming.length,
            color: context.ext.colors.primaryDark,
          ),
          12.h.height,
          ...upcoming.map(
            (v) => VaccineRecordCard(
              key: ValueKey('upcoming_${v.childVaccineId}'),
              vaccine: v,
              isUpdating: updatingVaccineId == v.childVaccineId,
              onMarkTaken: () => onMarkTaken(v),
            ),
          ),
          16.h.height,
        ],

        // Completed
        if (completed.isNotEmpty) ...[
          VaccineSectionHeader(
            title: context.trContext(TK.babyVaccineCompleted),
            count: completed.length,
            color: context.ext.colors.greenText,
          ),
          12.h.height,
          ...completed.map(
            (v) => VaccineRecordCard(
              key: ValueKey('completed_${v.childVaccineId}'),
              vaccine: v,
              isUpdating: updatingVaccineId == v.childVaccineId,
            ),
          ),
          16.h.height,
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Official schedule tab (grouped by age)
// ─────────────────────────────────────────────────────────────────────────────
class _VaccineScheduleTab extends StatelessWidget {
  final List groups;
  final int? updatingVaccineId;
  final int childId;
  final void Function(VaccineEntity) onMarkTaken;

  const _VaccineScheduleTab({
    required this.groups,
    required this.updatingVaccineId,
    required this.childId,
    required this.onMarkTaken,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return VaccineEmptyCard(
        message: context.trContext(TK.babyVaccineNoScheduleAvailable),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups
          .map(
            (group) => VaccineAgeGroupSection(
              key: ValueKey('age_${group.ageInMonths}'),
              group: group,
              childId: childId,
              updatingVaccineId: updatingVaccineId,
              onMarkTaken: onMarkTaken,
            ),
          )
          .toList(),
    );
  }
}

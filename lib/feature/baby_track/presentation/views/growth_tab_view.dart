import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/growth_record_list_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GrowthTabView extends StatefulWidget {
  const GrowthTabView({super.key});

  @override
  State<GrowthTabView> createState() => _GrowthTabViewState();
}

class _GrowthTabViewState extends State<GrowthTabView> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _save(BabyTrackCubit cubit) {
 

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild == null) {
      AppToast.warning(
        context,
        message: context.trContext(TK.babyVaccineSelectChildMsg),
      );
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || weight <= 0 || weight > 150) {
      AppToast.warning(
        context,
        message: context.trContext(TK.babyGrowthValidWeight),
      );
      return;
    }

    if (height == null || height <= 0 || height > 250) {
      AppToast.warning(
        context,
        message: context.trContext(TK.babyGrowthValidHeight),
      );
      return;
    }

    cubit.saveGrowthRecord(
      childId: activeChild.childId,
      request: AddGrowthRecordRequestModel(
        weightKg: weight,
        heightCm: height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BabyTrackCubit, BabyTrackState>(
      listener: (context, state) {
        if (state is GrowthRecordSaved) {
          _weightController.clear();
          _heightController.clear();
          
          AppToast.success(
            context,
            message: context.trContext(TK.babyGrowthSaved),
          );
        } else if (state is GrowthRecordError) {
          AppToast.error(
            context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<BabyTrackCubit>();
        final isLoading = state is GrowthRecordLoading;
        final activeChild = context.read<ActiveChildCubit>().state;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weight input field
                Text(
                  context.trContext(TK.babyGrowthWeightKgLabel),
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.h.height,
                TextFormFieldHelper(
                  controller: _weightController,
                  hint: context.trContext(TK.babyGrowthWeightInputHint),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  enableShadow: false,
                  borderRadius: BorderRadius.circular(16.r),
                  fillColor: context.theme.cardColor,
                  borderColor: context.ext.colors.primaryDark,
                  onValidate: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.trContext(TK.babyGrowthWeightRequired);
                    }
                    if (double.tryParse(value) == null) {
                      return context.trContext(TK.babyGrowthValidNumber);
                    }
                    return null;
                  },
                ),
                20.h.height,

                // Height input field
                Text(
                  context.trContext(TK.babyGrowthHeightCmLabel),
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.h.height,
                TextFormFieldHelper(
                  controller: _heightController,
                  hint: context.trContext(TK.babyGrowthHeightInputHint),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  enableShadow: false,
                  borderRadius: BorderRadius.circular(16.r),
                  fillColor: context.theme.cardColor,
                  borderColor: context.ext.colors.primaryDark,
                  onValidate: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.trContext(TK.babyGrowthHeightRequired);
                    }
                    if (double.tryParse(value) == null) {
                      return context.trContext(TK.babyGrowthValidNumber);
                    }
                    return null;
                  },
                ),
                20.h.height,

              
               
              
              


                // Save button
                CustomElevatedButton(
                  text: isLoading
                      ? context.trContext(TK.babySaving)
                      : context.trContext(TK.babyGrowthSaveRecord),
                  onPressed: isLoading ? null : () => _save(cubit),
                  backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
                  minimumSize: Size(double.infinity, 52.h),
                  textStyle: context.text.titleLarge!.copyWith(
                    color: context.theme.buttonTheme.colorScheme!.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                32.h.height,
                const Divider(),
                16.h.height,
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      context.trContext(TK.babyRecentRecords),
                      style: context.text.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (cubit.growthRecords.isNotEmpty)
                      Text(
                        '${cubit.growthRecords.length}',
                        style: context.text.bodyMedium!.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                16.h.height,

                if (state is GrowthRecordsLoading && cubit.growthRecords.isEmpty)
                  Skeletonizer(
                    enabled: true,
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => GrowthRecordListCard(
                          record: GrowthRecordEntity(
                            growthId: index,
                            childName: 'Baby',
                            recordDate: DateTime.now(),
                            ageInWeeks: index + 1,
                            ageInMonths: 0,
                            weightKg: 8.5,
                            heightCm: 70.0,
                          ),
                          onDelete: () {},
                        ),
                      ),
                    ),
                  )
                else if (state is GrowthRecordsError && cubit.growthRecords.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        state.errorMessage,
                        style: context.text.bodyMedium!.copyWith(
                          color: context.ext.colors.severityHigh,
                        ),
                      ),
                    ),
                  )
                else if (cubit.growthRecords.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.monitor_weight_outlined,
                            size: 48.sp,
                            color: context.colors.onSurfaceVariant.withValues(alpha: 0.3),
                          ),
                          12.h.height,
                          Text(
                            context.trContext(TK.babyNoRecordsYet),
                            style: context.text.bodyMedium!.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: cubit.growthRecords.map((record) {
                      return GrowthRecordListCard(
                        record: record,
                        isDeleting: cubit.deletingGrowthRecordId == record.growthId,
                        onDelete: () {
                          if (activeChild != null) {
                            cubit.deleteGrowthRecord(
                              childId: activeChild.childId,
                              recordId: record.growthId,
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

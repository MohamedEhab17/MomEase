import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/widgets/custom_drop_down.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/children/presentation/widgets/add_edit_child_widgets.dart';
import 'package:new_mama/feature/children/presentation/widgets/children_ui_components.dart';

class AddEditChildView extends StatefulWidget {
  /// If null → Add mode. If set → Edit mode.
  final Child? child;

  const AddEditChildView({super.key, this.child});

  @override
  State<AddEditChildView> createState() => _AddEditChildViewState();
}

class _AddEditChildViewState extends State<AddEditChildView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;

  String? _gender;
  String? _deliveryType;
  String? _feedingType;
  DateTime? _selectedDate;

  bool get _isEdit => widget.child != null;

  static const _deliveryTypes = ['Normal', 'Cesarean'];
  static const _feedingTypes = ['Breastfeeding', 'Formula', 'SolidFood'];

  @override
  void initState() {
    super.initState();
    final c = widget.child;
    _nameController = TextEditingController(text: c?.fullName ?? '');
    _dateController = TextEditingController(
      text: c != null ? _formatDisplayDate(c.birthDate) : '',
    );
    _gender = c?.gender;
    _deliveryType = c?.deliveryType;
    _feedingType = c?.feedingTypeForBaby;
    if (c != null) {
      _selectedDate = _tryParseDate(c.birthDate);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDisplayDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  DateTime? _tryParseDate(String iso) {
    try {
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          colorScheme: context.theme.colorScheme.copyWith(
            primary: context.ext.colors.primaryDark,
            onPrimary: context.colors.onPrimary,
            onSurface: context.colors.onSurface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  String? _toIso(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day).toUtc().toIso8601String();

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) {
      AppToast.error(
        context,
        message: context.trContext(TK.childrenSelectGender),
      );
      return;
    }
    if (_deliveryType == null) {
      AppToast.error(
        context,
        message: context.trContext(TK.childrenSelectDelivery),
      );
      return;
    }
    if (_feedingType == null) {
      AppToast.error(
        context,
        message: context.trContext(TK.childrenSelectFeeding),
      );
      return;
    }
    if (_selectedDate == null) {
      AppToast.error(
        context,
        message: context.trContext(TK.childrenSelectBirth),
      );
      return;
    }

    final cubit = context.read<ChildrenCubit>();
    if (_isEdit) {
      cubit.updateChild(
        widget.child!.childId,
        UpdateChildParams(
          fullName: _nameController.text.trim(),
          gender: _gender,
          birthDate: _toIso(_selectedDate!),
          deliveryType: _deliveryType,
          feedingTypeForBaby: _feedingType,
        ),
      );
    } else {
      cubit.createChild(
        CreateChildParams(
          fullName: _nameController.text.trim(),
          gender: _gender!,
          birthDate: _toIso(_selectedDate!)!,
          deliveryType: _deliveryType!,
          feedingTypeForBaby: _feedingType!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenCubit, ChildrenState>(
      listener: (context, state) {
        if (state is ChildActionSuccess) {
          AppToast.success(context, message: context.trContext(state.message));
          context.pop();
        } else if (state is ChildrenError) {
          AppToast.error(context, message: context.trContext(state.message));
          context.read<ChildrenCubit>().restoreLoaded();
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            _isEdit
                ? context.trContext(TK.childrenEditBabyInfo)
                : context.trContext(TK.childrenAddNewBaby),
            style: context.text.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.colors.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<ChildrenCubit, ChildrenState>(
          builder: (context, state) {
            final isLoading = state is ChildrenActionLoading;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header illustration
                        Center(
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  context.ext.colors.primaryLighter,
                                  context.ext.colors.primaryAccent,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _isEdit ? '✏️' : '👶',
                                style: TextStyle(fontSize: 36.sp),
                              ),
                            ),
                          ),
                        ),
                        24.height,

                        FormSectionLabel(
                          label: context.trContext(TK.childrenBabyFullName),
                        ),
                        8.height,
                        TextFormFieldHelper(
                          controller: _nameController,
                          hint: context.trContext(TK.childrenFullNameHint),
                          borderColor: context.ext.colors.primaryDark,
                          fillColor: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          onValidate: (v) => (v == null || v.trim().isEmpty)
                              ? context.trContext(TK.childrenNameRequired)
                              : null,
                        ),
                        20.height,

                        FormSectionLabel(
                          label: context.trContext(TK.childrenGender),
                        ),
                        12.height,
                        GenderSelector(
                          selected: _gender,
                          onChanged: (g) => setState(() => _gender = g),
                        ),
                        20.height,

                        FormSectionLabel(
                          label: context.trContext(TK.childrenDateOfBirth),
                        ),
                        8.height,
                        TextFormFieldHelper(
                          controller: _dateController,
                          hint: context.trContext(TK.childrenDateHint),
                          borderColor: context.ext.colors.primaryDark,
                          fillColor: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          isReadOnly: true,
                          onTap: _pickDate,
                          suffixWidget: Icon(
                            Icons.calendar_today_outlined,
                            color: context.ext.colors.primaryDark,
                          ),
                          onValidate: (_) => null,
                        ),
                        20.height,

                        FormSectionLabel(
                          label: context.trContext(TK.childrenDeliveryType),
                        ),
                        8.height,
                        CustomDropdown(
                          items: _deliveryTypes,
                          value: _deliveryType,
                          hintText: context.trContext(
                            TK.childrenDeliverySelect,
                          ),
                          itemLabelBuilder: (item) => item == 'Normal'
                              ? context.trContext(TK.childrenNormal)
                              : context.trContext(TK.childrenCesarean),
                          onChanged: (v) => setState(() => _deliveryType = v),
                        ),
                        20.height,

                        FormSectionLabel(
                          label: context.trContext(TK.childrenFeedingType),
                        ),
                        8.height,
                        CustomDropdown(
                          items: _feedingTypes,
                          value: _feedingType,
                          hintText: context.trContext(TK.childrenFeedingSelect),
                          itemLabelBuilder: (item) => item == 'Breastfeeding'
                              ? context.trContext(TK.childrenBreastfeeding)
                              : item == 'Formula'
                              ? context.trContext(TK.childrenFormula)
                              : context.trContext(TK.childrenSolidFood),
                          onChanged: (v) => setState(() => _feedingType = v),
                        ),
                        40.height,

                        CustomElevatedButton(
                          text: _isEdit
                              ? context.trContext(TK.childrenSaveChanges)
                              : context.trContext(TK.childrenAddBaby),
                          minimumSize: Size(double.infinity, 56.h),
                          onPressed: isLoading ? null : () => _submit(context),
                        ),
                        24.height,
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: context.colors.onSurface.withValues(alpha: 50),
                    child: Center(
                      child: CustomLoadingIndicator(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

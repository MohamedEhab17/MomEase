import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/manage_profile_cubit/manage_profile_cubit.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/manage_profile_cubit/manage_profile_state.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ManageProfileCubit>(),
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: FeaturesHeader(
          title: context.trContext(TK.drawerSecurity),
          showChatbotIcon: false,
        ),
    

        body: BlocListener<ManageProfileCubit, ManageProfileState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              AppToast.success(context, message: state.message);
              // Clear autofill context to prevent native crashes on login
              TextInput.finishAutofillContext();
              // Force logout navigation
              context.go(AppRoutesPaths.login);
            } else if (state is ManageProfileError) {
              AppToast.error(context, message: state.message);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  32.h.height,
                  _buildFields(),
                  150.h.height,
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          context.trContext(TK.authChangePassword),
          
          style: context.text.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        8.h.height,
        Text(
          context.trContext(TK.authChangePasswordInstructions) 
         ,
          style: context.text.bodyMedium!.copyWith(
            color: context.colors.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildFields() {
    return AutofillGroup(
      child: Column(
        children: [
          TextFormFieldHelper(
            fillColor: context.theme.cardColor,
            controller: _currentPasswordController,
            label:  context.trContext(TK.authCurrentPassword),
            hint: context.trContext(TK.authCurrentPassword),
            isVisible: true,
            isPassword: true,
            borderRadius: BorderRadius.circular(64),
            autoFillHint: [AutofillHints.password],
            //prefixIcon: Icon(Icons.lock_open, color: context.colors.primary),
            onValidate: (value) => validatePassword(value),
          ),
          20.h.height,
          TextFormFieldHelper(
            fillColor: context.theme.cardColor,
            controller: _newPasswordController,
            borderRadius: BorderRadius.circular(64),
            label:  context.trContext(TK.authChangePasswordNewHint),
            hint:  context.trContext(TK.authChangePasswordNewHint),
            isVisible: true,
            isPassword: true,
            autoFillHint: [AutofillHints.newPassword],
          //  prefixIcon: Icon(Icons.lock_outline, color: context.colors.primary),
            onValidate: (value) => validatePassword(value),
            //
            // (v) => v!.length < 8 ? "Minimum 8 characters" : null,
          ),
          20.h.height,
          TextFormFieldHelper(
            fillColor: context.theme.cardColor,
            controller: _confirmPasswordController,
            borderRadius: BorderRadius.circular(64),
            label:  context.trContext(TK.authConfirmNewPassword),
            hint:  context.trContext(TK.authConfirmNewPassword),
            isVisible: true,
            isPassword: true,
            autoFillHint: [AutofillHints.newPassword],
           // prefixIcon: Icon(Icons.lock_reset, color: context.colors.primary),
            onValidate: (value) =>
                validateConfirmPassword(value, _newPasswordController.text),
            
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ManageProfileCubit, ManageProfileState>(
      builder: (context, state) {
        return CustomElevatedButton(
          minimumSize: Size(double.infinity, 52.h),
          text: state is ManageProfileLoading
              ? context.trContext(TK.authChangePasswordUpdatingBtn)
              : context.trContext(TK.authChangePasswordUpdateBtn),
          onPressed: state is ManageProfileLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ManageProfileCubit>().changePassword(
                      currentPassword: _currentPasswordController.text,
                      newPassword: _newPasswordController.text,
                      confirmNewPassword: _confirmPasswordController.text,
                    );
                  }
                },
        );
      },
    );
  }
}

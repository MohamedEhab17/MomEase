import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/manage_profile_cubit/manage_profile_cubit.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/manage_profile_cubit/manage_profile_state.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/profile_cubit/profile_state.dart';

class ManageProfileView extends StatefulWidget {
  const ManageProfileView({super.key});

  @override
  State<ManageProfileView> createState() => _ManageProfileViewState();
}

class _ManageProfileViewState extends State<ManageProfileView> {
  final _profileFormKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _checkInitialState();
  }

  void _initControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
  }

  void _checkInitialState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<ProfileCubit>().state;
      if (state is ProfileLoaded) {
        _fillUserData(state);
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _fillUserData(ProfileLoaded state) {
    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = state.user.firstName;
      _lastNameController.text = state.user.lastName;
      _phoneController.text = state.user.phone;
      _ageController.text = state.user.age.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ManageProfileCubit>(),
      child: Scaffold(
        appBar: FeaturesHeader(
          title: context.trContext(TK.drawerManageProfile),
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: MultiBlocListener(
          listeners: [
            BlocListener<ManageProfileCubit, ManageProfileState>(
              listener: _onManageProfileStateChanged,
            ),
            BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLoaded) _fillUserData(state);
              },
            ),
          ],
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // _buildAppBar(context),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileSection(context),
                    100.h.height,
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onManageProfileStateChanged(
    BuildContext context,
    ManageProfileState state,
  ) {
    if (state is ManageProfileSuccess) {
      AppToast.success(context, message: "Profile updated successfully");
      context.read<ProfileCubit>().getProfile();
    } else if (state is ManageProfileError) {
      AppToast.error(context, message: state.message);
    }
  }

  Widget _buildProfileSection(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Form(
            key: _profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileFields(context),
                150.h.height,
                _buildUpdateProfileButton(context),
              ],
            ),
          );
        } else if (state is ProfileLoading) {
          return const Center(child: CustomLoadingIndicator());
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileFields(BuildContext context) {
    return Column(
      children: [
        TextFormFieldHelper(
          borderRadius: BorderRadius.circular(64),
          fillColor: context.theme.cardColor,
          controller: _firstNameController,
          label: context.trContext(TK.authSignUpFirstNameHint),
          hint: context.trContext(TK.authSignUpFirstNameHint),
          isVisible: true,
         // prefixIcon: Icon(Icons.person, color: context.colors.primary),
          onValidate: validateUsername,
        ),
        20.h.height,
        TextFormFieldHelper(
          borderRadius: BorderRadius.circular(64),
          fillColor: context.theme.cardColor,
          controller: _lastNameController,
          label: context.trContext(TK.authSignUpLastNameHint),
          hint: context.trContext(TK.authSignUpLastNameHint),
          isVisible: true,
        //  prefixIcon: Icon(Icons.person_outline, color: context.colors.primary),
          // onValidate: (v) => v!.isEmpty ? "Required" : null,
          onValidate: validateUsername,
        ),
        20.h.height,
        TextFormFieldHelper(
          borderRadius: BorderRadius.circular(64),
          fillColor: context.theme.cardColor,
          controller: _phoneController,
          label: context.trContext(TK.authSignUpPhoneNumber),
          hint: context.trContext(TK.authSignUpPhoneNumber),
          isVisible: true,
          keyboardType: TextInputType.phone,
          onValidate: validatePhone,
        //  prefixIcon: Icon(Icons.phone, color: context.colors.primary),
          // onValidate: (v) => v!.isEmpty ? "Required" : null,
        ),
        20.h.height,
        TextFormFieldHelper(
          borderRadius: BorderRadius.circular(64),
          fillColor: context.theme.cardColor,
          controller: _ageController,
          label: context.trContext(TK.authSignUpAge),
          hint:  context.trContext(TK.authSignUpAge),
          isVisible: true,
          keyboardType: TextInputType.number,
        //  prefixIcon: Icon(Icons.cake, color: context.colors.primary),
          onValidate: validateRequired,
        ),
      ],
    );
  }

  Widget _buildUpdateProfileButton(BuildContext context) {
    return BlocBuilder<ManageProfileCubit, ManageProfileState>(
      builder: (context, manageState) {
        return CustomElevatedButton(
          minimumSize: Size(double.infinity, 52.h),

          text: manageState is ManageProfileLoading
              ? "Updating..."
              : "Update Profile",
          onPressed: manageState is ManageProfileLoading
              ? null
              : () {
                  if (_profileFormKey.currentState!.validate()) {
                    context.read<ManageProfileCubit>().updateProfile(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      phone: _phoneController.text,
                      age: int.parse(_ageController.text),
                    );
                  }
                },
        );
      },
    );
  }
}

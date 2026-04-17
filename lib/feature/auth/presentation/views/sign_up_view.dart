import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/enums/verification_type.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/helper/google_auth_helper.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';
import 'package:new_mama/feature/auth/presentation/widgets/login_social_auth_section.dart';
import 'package:new_mama/feature/auth/presentation/widgets/signup_button.dart';
import 'package:new_mama/feature/auth/presentation/widgets/signup_footer.dart';
import 'package:new_mama/feature/auth/presentation/widgets/signup_form.dart';
import 'package:new_mama/feature/auth/presentation/widgets/signup_header.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;

  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    final (idToken, error) = await getIt<GoogleAuthHelper>().getGoogleIdToken();
    if (mounted) {
      if (idToken != null) {
        context.read<AuthCubit>().googleLogin(idToken);
      } else if (error != null) {
        AppToast.error(context, message: error);
      }
    }
  }

  bool isValid = false;
  void validateForm() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.push(
            AppRoutesPaths.emailVerification,
            extra: {
              'type': VerificationType.signup,
              'email': _emailController.text.trim(),
            },
          );
        } else if (state is AuthError) {
          AppToast.error(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            padding: EdgeInsetsDirectional.only(
              start: 16.w,
              end: 16.w,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignUpHeader(),
                  SignUpForm(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    ageController: _ageController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    onFormChanged: validateForm,
                  ),
                  32.h.height,
                  SignUpButton(
                    isValid: isValid,
                    onPressed: () {
                      context.read<AuthCubit>().register(
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            phone: _phoneController.text.trim(),
                            age: int.tryParse(_ageController.text) ?? 20,
                          );
                    },
                  ),
                  12.h.height,
                  LoginSocialAuthSection(
                    onGooglePressed: () {
                      FocusScope.of(context).unfocus();
                      _handleGoogleSignIn();
                    },
                  ),
                  24.h.height,
                  const SignUpFooter(),
                  24.h.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
import 'package:new_mama/core/helper/biometric_helper.dart';
import 'package:new_mama/core/helper/google_auth_helper.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';
import 'package:new_mama/feature/auth/presentation/widgets/login_button_row.dart';
import 'package:new_mama/feature/auth/presentation/widgets/login_footer.dart';
import 'package:new_mama/feature/auth/presentation/widgets/login_form.dart';
import 'package:new_mama/feature/auth/presentation/widgets/login_header.dart';
import 'package:new_mama/feature/auth/presentation/widgets/login_social_auth_section.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _checkBiometrics();
  }

  bool _isBiometricAvailable = false;
  Future<void> _checkBiometrics() async {
    final available = await getIt<BiometricHelper>().isBiometricAvailable();
    if (mounted) {
      setState(() {
        _isBiometricAvailable = available;
      });
    }
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
      listenWhen: (prev, next) => next is AuthSuccess || next is AuthError,
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(AppRoutesPaths.appSectionView);
        } else if (state is AuthError) {
          if (state.message.contains(
            "Please verify your email before logging in.",
          )) {
            context.go(
              AppRoutesPaths.emailVerification,
              extra: {
                'type': VerificationType.signup,
                'email': _emailController.text.trim(),
              },
            );
          } else {
            AppToast.error(context, message: state.message);
          }
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
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginHeader(),
                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onFormChanged: validateForm,
                    ),
                    48.h.height,
                    LoginButtonRow(
                      isValid: isValid,
                      isBiometricAvailable: _isBiometricAvailable,
                      onLoginPressed: () {
                        FocusScope.of(context).unfocus();
                        context.read<AuthCubit>().login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      },
                      onBiometricPressed: () {
                        FocusScope.of(context).unfocus();
                        context.read<AuthCubit>().biometricLogin();
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
                    const LoginFooter(),
                    24.h.height,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/routers/app_router.dart';
import 'package:new_mama/core/services/fcm_service.dart';
import 'package:new_mama/core/theme/app_theme.dart';
import 'package:new_mama/core/theme/cubit/theme_cubit.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register the background message handler BEFORE any other Firebase call.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await configureDependencies();
  await AppRouter.initRouter();

  // Initialize local notifications + foreground/background listeners AFTER router initialization.
  await FcmService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const NewMama(),
      ),
    ),
  );
}

class NewMama extends StatelessWidget {
  const NewMama({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()..loadSavedTheme()),
        BlocProvider.value(
          value: getIt<LanguageCubit>()..loadSavedLanguage(),
        ),
        BlocProvider.value(value: getIt<ActiveChildCubit>()),
        BlocProvider.value(value: getIt<ChildrenCubit>()),
        BlocProvider.value(value: getIt<AuthCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411, 899),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return BlocBuilder<ThemeCubit, AppThemeMode>(
                builder: (context, themeMode) {
                  ThemeData getTheme() {
                    switch (themeMode) {
                      case AppThemeMode.pink:
                        return AppTheme.pinkTheme;
                      case AppThemeMode.blue:
                        return AppTheme.blueTheme;
                      case AppThemeMode.dark:
                        return AppTheme.darkTheme;
                    }
                  }

                  return ToastificationWrapper(
                    child: MaterialApp.router(
                      title: 'New Mama',
                      theme: getTheme(),
                      themeAnimationCurve: Curves.fastOutSlowIn,
                      themeAnimationDuration: const Duration(
                        milliseconds: 1000,
                      ),
                      routerConfig: AppRouter.router,
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: locale,
                      builder: DevicePreview.appBuilder,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

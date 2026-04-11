import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/routers/app_router.dart';
import 'package:new_mama/core/theme/app_theme.dart';
import 'package:new_mama/core/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await AppRouter.initRouter();

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => NewMama()),
  );
}

class NewMama extends StatelessWidget {
  const NewMama({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: ScreenUtilInit(
        designSize: const Size(411, 899),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
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

              return MaterialApp.router(
                title: 'New Mama',
                theme: getTheme(),
                themeAnimationCurve: Curves.fastOutSlowIn,
                themeAnimationDuration: const Duration(milliseconds: 1000),
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
              );
            },
          );
        },
      ),
    );
  }
}

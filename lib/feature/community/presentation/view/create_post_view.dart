import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/presentation/widgets/create_post_components/create_post_view_body.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.theme.scaffoldBackgroundColor,
        statusBarIconBrightness: context.theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: context.theme.brightness,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: const CreatePostViewBody(),
        ),
      ),
    );
  }
}

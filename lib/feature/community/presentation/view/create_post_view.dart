import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/presentation/widgets/create_post_components/create_post_view_body.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: const CreatePostViewBody(),
      ),
    );
  }
}

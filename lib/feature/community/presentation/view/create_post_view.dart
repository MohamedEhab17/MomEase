import 'package:flutter/material.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/app_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/create_post_view_body.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: const CreatePostViewBody(),
    );
  }
}
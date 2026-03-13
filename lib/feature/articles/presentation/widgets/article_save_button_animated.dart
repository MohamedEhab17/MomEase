import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_state.dart';

class ArticleSaveButtonAnimated extends StatefulWidget {
  final String articleId;

  const ArticleSaveButtonAnimated({super.key, required this.articleId});

  @override
  State<ArticleSaveButtonAnimated> createState() =>
      _ArticleSaveButtonAnimatedState();
}

class _ArticleSaveButtonAnimatedState extends State<ArticleSaveButtonAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context, bool isSaved) async {
    await _controller.forward();
    if (context.mounted) {
      context.read<ArticleCubit>().toggleSaveArticle(widget.articleId);
    }
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        final article = state.articles.firstWhere(
          (a) => a.id == widget.articleId,
          orElse: () => throw Exception('Article not found!'),
        );

        return ScaleTransition(
          scale: _scaleAnimation,
          child: CustomElevatedButton(
            text: article.isSaved ? "Saved" : "Save Article",
            minimumSize: Size(double.infinity, 52.h),
            onPressed: () => _handleSave(context, article.isSaved),
            backgroundColor: article.isSaved
                ? AppColors.lightTextDisabled
                : AppColors.primaryDark,
          ),
        );
      },
    );
  }
}

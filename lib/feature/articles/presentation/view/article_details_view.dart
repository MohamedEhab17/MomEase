import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_details_body.dart';

class ArticleDetailsView extends StatefulWidget {
  final ArticleModel article;

  const ArticleDetailsView({super.key, required this.article});

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // Parallax Header Image
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double offset = 0;
              if (_scrollController.hasClients) {
                offset = _scrollController.offset;
                if (offset < 0) {
                  offset = 0; // Prevent pulling down to show background
                }
              }
              return Positioned(
                top: -offset * 0.5,
                left: 0,
                right: 0,
                height: 380.h,
                child: child!,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(widget.article.imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(100),
                        Colors.transparent,
                        Colors.black.withAlpha(200),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70.h, // Space for the overlapping body radius
                  left: 20.w,
                  right: 20.w,
                  child: Text(
                    widget.article.title,
                    style: AppStyles.styleInter24.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Body covering the header
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 330.h), // pushes body down to expose image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30.r),
                      ),
                    ),
                    child: ArticleDetailsBody(article: widget.article),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Top Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Transform.translate(
                offset: const Offset(-4, -1),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryDark,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

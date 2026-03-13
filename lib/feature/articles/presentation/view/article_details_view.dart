import 'package:flutter/material.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_details_body.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_sliver_header.dart';

class ArticleDetailsView extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailsView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Passing the imageUrl to the awesome Sliver Header if it accepts it in the future
            ArticlesSliverHeader(article: article),
            SliverToBoxAdapter(child: ArticleDetailsBody(article: article)),
          ],
        ),
      ),
    );
  }
}

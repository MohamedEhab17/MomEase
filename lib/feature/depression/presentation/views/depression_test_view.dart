import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/depression/data/dummy/dummy_questions.dart';
import 'package:new_mama/feature/depression/presentation/view_model/depression_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/depression_state.dart';
import 'package:new_mama/feature/depression/presentation/widgets/answers_option.dart';

class DepressionTestView extends StatelessWidget {
  const DepressionTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepressionCubit, DepressionState>(
      listener: (context, state) {
        if (state is DepressionFinished) {
          while (context.canPop()) {
            context.pop();
          }
          context.push(
            AppRoutesPaths.depressionResultView,
            extra: state.totalScore,
          );
        }
      },
      builder: (context, state) {
        int currentIndex = 0;
        int? selectedAnswerIndex;

        if (state is DepressionAnswering) {
          currentIndex = state.currentIndex;
          selectedAnswerIndex = state.selectedAnswerIndex;
        }

        final currentQuestion = dummyDepressionQuestions[currentIndex];
        final totalQuestions = dummyDepressionQuestions.length;
        final progress = (currentIndex + 1) / totalQuestions;

        return Scaffold(
          appBar: FeaturesHeader(title: 'Healthy check-In'),
          body: Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 32.h),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: context.ext.colors.greyMedium,
                        color: context.ext.colors.primaryDark,
                        value: progress,
                        borderRadius: BorderRadius.circular(24.r),
                        minHeight: 6.h,
                      ),
                      8.h.height,
                      Text(
                        'Question ${currentIndex + 1} of $totalQuestions',
                        style: context.text.bodyMedium!,
                      ),
                      48.h.height,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentQuestion.query,
                          style: context.text.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      32.h.height,
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: 16.h.bottomPadding,
                      child: AnswersOptions(
                        answer: currentQuestion.answers[index],
                        isSelected: selectedAnswerIndex == index,
                        onTap: () {
                          context.read<DepressionCubit>().selectAnswer(index);
                        },
                      ),
                    ),
                    childCount: currentQuestion.answers.length,
                  ),
                ),
                SliverToBoxAdapter(child: 44.h.height),
                SliverToBoxAdapter(
                  child: CustomElevatedButton(
                    text: currentIndex == totalQuestions - 1
                        ? 'Finish Check-In'
                        : 'Next Question',
                    onPressed: selectedAnswerIndex == null
                        ? () {}
                        : () {
                            context.read<DepressionCubit>().nextQuestion();
                          },
                    minimumSize: Size(double.infinity, 52.h),
                    backgroundColor: selectedAnswerIndex == null
                        ? context.theme.buttonTheme.colorScheme!.tertiary
                              .withAlpha(100)
                        : context.theme.buttonTheme.colorScheme!.primary,
                    borderColor: selectedAnswerIndex == null
                        ? context.theme.buttonTheme.colorScheme!.tertiary
                              .withAlpha(100)
                        : context.theme.buttonTheme.colorScheme!.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';
import 'package:new_mama/feature/depression/presentation/view_model/questions_cubit/questions_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/questions_cubit/questions_state.dart';
import 'package:new_mama/feature/depression/presentation/view_model/submit_cubit/submit_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/submit_cubit/submit_state.dart';
import 'package:new_mama/feature/depression/presentation/widgets/answers_option.dart';
import 'package:skeletonizer/skeletonizer.dart';


class DepressionTestView extends StatefulWidget {
  final Assessments assessment;
  const DepressionTestView({super.key, required this.assessment});

  @override
  State<DepressionTestView> createState() => _DepressionTestViewState();
}

class _DepressionTestViewState extends State<DepressionTestView> {
  @override
  void initState() {
    super.initState();
    context.read<QuestionsCubit>().fetchQuestions(widget.assessment.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitCubit, SubmitState>(
      listener: (context, state) {
        if (state is SubmitSuccess) {
          context.pushReplacement(
            AppRoutesPaths.depressionResultView,
            extra: {
              'assessment': widget.assessment,
              'resultId': state.result.id,
            },
          );
        } else if (state is SubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: Scaffold(
        appBar: FeaturesHeader(
          title: context.trContext(TK.depressionAppBarTitle),
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.only(
            end: 20.w,
            start: 20.w,
            top: 32.h,
          ),
          child: BlocBuilder<QuestionsCubit, QuestionsState>(
            builder: (context, state) {
              if (state is QuestionsLoading || state is QuestionsInitial) {
                return Skeletonizer(
                  enabled: true,
                  child: _buildTestContent(
                    context,
                    currentIndex: 0,
                    totalQuestions: 10,
                    options: List.generate(
                      4,
                      (index) => const Option(
                        id: 0,
                        questionId: 0,
                        text: 'Sample option text',
                        textAr: 'نص خيار تجريبي',
                        score: 0,
                        optionOrder: 0,
                      ),
                    ),
                    selectedAnswerId: null,
                    isLoadingOptions: false,
                    assessmentId: widget.assessment.id,
                  ),
                );
              }

              if (state is QuestionsError) {
                return Center(child: Text(state.message));
              }

              if (state is QuestionsActive) {
                if (state.questions.isEmpty) {
                  return const Center(child: Text('No questions available.'));
                }

                final currentIndex = state.currentIndex;
                final currentQuestion = state.questions[currentIndex];
                final totalQuestions = state.questions.length;

                final selectedAnswerId =
                    state.selectedAnswers[currentQuestion.id];
                final options = state.optionsCache[currentQuestion.id] ?? [];
                // If options are empty but we are loading, show skeletons
                final isLoadingOptions =
                    state.isLoadingOptions && options.isEmpty;

                return Skeletonizer(
                  enabled: isLoadingOptions,
                  child: _buildTestContent(
                    context,
                    currentIndex: currentIndex,
                    totalQuestions: totalQuestions,
                    options: isLoadingOptions
                        ? List.generate(
                            4,
                            (index) => const Option(
                                  id: 0,
                                  questionId: 0,
                                  text: 'Sample option text',
                                  textAr: 'نص خيار تجريبي',
                                  score: 0,
                                  optionOrder: 0,
                                ))
                        : options,
                    selectedAnswerId: selectedAnswerId,
                    isLoadingOptions: isLoadingOptions,
                    assessmentId: widget.assessment.id,
                    question: currentQuestion,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTestContent(
    BuildContext context, {
    required int currentIndex,
    required int totalQuestions,
    required List<Option> options,
    required int? selectedAnswerId,
    required bool isLoadingOptions,
    required int assessmentId,
    Question? question,
  }) {
    final progress = (currentIndex + 1) / totalQuestions;
    
    return CustomScrollView(
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
                context.trContext(
                  'depression.question_progress',
                  namedArgs: {
                    'current': '${currentIndex + 1}',
                    'total': '$totalQuestions',
                  },
                ),
                style: context.text.bodyMedium!,
              ),
              48.h.height,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  question?.text ?? '',
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
            (context, index) {
              final option = options[index];
              return Padding(
                padding: 16.h.bottomPadding,
                child: AnswersOptions(
                  answer: option.text,
                  isSelected: selectedAnswerId == option.id,
                  onTap: () {
                    context.read<QuestionsCubit>().selectAnswer(option.id);
                  },
                ),
              );
            },
            childCount: options.length,
          ),
        ),


        SliverToBoxAdapter(child: 44.h.height),
        SliverToBoxAdapter(child: Builder(builder: (ctx) {
          return BlocBuilder<SubmitCubit, SubmitState>(builder: (subContext, subState) {
            final isSubmitting = subState is SubmitLoading;
            return CustomElevatedButton(
              text: currentIndex == totalQuestions - 1
                  ? context.trContext(TK.depressionFinishCheckIn)
                  : context.trContext(TK.depressionNextQuestion),
              onPressed: (selectedAnswerId == null || isSubmitting)
                  ? () {}
                  : () {
                      if (currentIndex == totalQuestions - 1) {
                        final answers = context.read<QuestionsCubit>().buildSubmitAnswers();
                        context.read<SubmitCubit>().submitAnswers(assessmentId, answers);
                      } else {
                        context.read<QuestionsCubit>().nextQuestion();
                      }
                    },
              minimumSize: Size(double.infinity, 52.h),
              backgroundColor: selectedAnswerId == null
                  ? context.theme.buttonTheme.colorScheme!.tertiary.withAlpha(100)
                  : context.theme.buttonTheme.colorScheme!.primary,
              borderColor: selectedAnswerId == null
                  ? context.theme.buttonTheme.colorScheme!.tertiary.withAlpha(100)
                  : context.theme.buttonTheme.colorScheme!.primary,
            );
          });
        })),
      ],
    );
  }
}


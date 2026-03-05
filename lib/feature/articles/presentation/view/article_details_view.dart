import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_sliver_header.dart';

class ArticleDetailsView extends StatelessWidget {
  const ArticleDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            ArticlesSliverHeader(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 40.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 132,
                          offset: Offset(0, -72),
                          color: AppColors.lightTextPrimary.withAlpha(63),
                          spreadRadius: 0,
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Why Support Matters',
                              style: AppStyles.styleInter16.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              AppIcons.iconsClock,
                              width: 22.w,
                              height: 22.h,
                            ),
                            Text(
                              '14 mins',
                              style: AppStyles.styleInter12.copyWith(
                                color: Color(0xff808080),
                              ),
                            ),
                          ],
                        ),
                        Text('''
New motherhood can feel isolating. Having a support network: 
• Reduces risk of postpartum depression 
• Provides practical help 
• Offers emotional validation 
• Creates lasting friendships 
• Helps you feel less alone
''', style: AppStyles.styleInter14),
                        Text(
                          'Finding Your People',
                          style: AppStyles.styleInter16.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          '''

Local Groups''',
                          style: AppStyles.styleInter12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary.withAlpha(178),
                          ),
                        ),
                        Text('''
• New parent classes at hospitals 
• Library story times 
• Mommy-and-me fitness classes 
• Breastfeeding support groups 
• Postpartum support groups''', style: AppStyles.styleInter14),
                        Text(
                          ' Online Communities',
                          style: AppStyles.styleInter12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary.withAlpha(178),
                          ),
                        ),
                        Text('''
• Due date groups on social media 
• Local parenting Facebook groups 
• Apps for meeting parent friends 
• Virtual support groups''', style: AppStyles.styleInter14),
                        Text(
                          ' Through Existing Networks',
                          style: AppStyles.styleInter12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary.withAlpha(178),
                          ),
                        ),
                        Text('''
• Friends with babies 
• Coworkers on parental leave 
• Neighbors with young children 
• Your own parents/family
''', style: AppStyles.styleInter14),
                        Text(
                          'Building Meaningful Connections',
                          style: AppStyles.styleInter16.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('''

**Be Vulnerable**: Share your real experiences, not just highlight reel **Reach Out First**: Others are probably feeling isolated too **Regular Meet-ups**: Consistency builds deeper friendships **Support Others**: Friendship is a two-way street **Be Patient**: Deep friendships take time to develop
Different Types of Support
**Practical Help** • Someone to hold baby while you shower • Meal trains • Help with older children • Household tasks
**Emotional Support** • Non-judgmental listening • Validation of feelings • Sharing experiences • Celebrating wins together
**Professional Support** • Pediatrician • Lactation consultant • Therapist or counselor • Postpartum doula
When You Don't Have Local Support
• Join online communities
• Schedule regular video calls with distant friends/family
• Hire help when possible
• Be extra kind to yourself
• Know that this phase is temporary
Red Flags in Support
Not all support is helpful. Distance yourself from: • Judgmental comments • Unsolicited advice • Comparison and competition • Lack of respect for boundaries • Dismissal of your feelings
Remember
You deserve support. You don't have to do this alone. Building your village takes effort, but it's worth it. Your mental health and happiness matter - for you and for your baby.

''', style: AppStyles.styleInter14),

                        76.height,
                        CustomElevatedButton(
                          text: "Save Article",
                          minimumSize: Size(double.infinity, 52.h),
                          onPressed: () {},
                          backgroundColor: AppColors.primaryHard,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

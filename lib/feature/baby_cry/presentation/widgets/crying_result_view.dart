
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';

class CryingResultView extends StatelessWidget {
  const CryingResultView({
    super.key,
    required this.advices,
  });

  final List<String> advices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          SvgPicture.asset(
            AppIcons.iconsCheck,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
          24.h.height,
          Text('Baby Might Be:', style: AppStyles.styleInter24),
          12.h.height,
          Text(
            'Discomfort',
            style: AppStyles.styleInter24.copyWith(color: Color(0xffFFC107)),
          ),
          40.h.height,
          Text(
            'The cry sounds suggest your baby might be uncomfortable. This could be due to a wet diaper, temperature, or clothing.',
            style: AppStyles.styleInter16.copyWith(
              color: AppColors.lightTextPrimary.withAlpha(178),
            ),
            //textAlign: .center,
            softWrap: true,
          ),
          32.h.height,
          CustomInstructionsRecommendations(
            advices: advices,
            title: 'Recommend Steps',
          ),
          44.h.height,
          CustomElevatedButton(
            text: 'Analyze another cry',
            backgroundColor: AppColors.primaryHard,
            minimumSize: Size(double.infinity, 52.h),
            onPressed: () {},
            textStyle: AppStyles.styleInter20.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          24.h.height,
          CustomElevatedButton(
            text: 'Back to Home',
            backgroundColor: AppColors.lightBackground,
            minimumSize: Size(double.infinity, 52.h),
            onPressed: () {},
            borderColor: AppColors.primaryHard,
            textStyle: AppStyles.styleInter20.copyWith(
              color: AppColors.primaryHard,
            ),
          ),
        ],
      ),
    );
  }
}

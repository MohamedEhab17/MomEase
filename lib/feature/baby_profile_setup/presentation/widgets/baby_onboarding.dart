import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class BabyOnboarding extends StatelessWidget {
  const BabyOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          80.height,
          SvgPicture.asset(
            AppImages.imagesMama,
            colorMapper: AppSvgColorMapper(
              from: const Color(0xffFF9BBC),
              to: context.colors.primary,
            ),
          ),
          60.height,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.trContext(TK.babySetupHello),
                  style: context.text.displaySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: context.trContext(TK.babySetupMama), style: context.text.headlineLarge!),
              ],
            ),
          ),
          6.height,
          Text(
            context.trContext(TK.babySetupGetToKnow),
            style: context.text.titleSmall!,
          ),
          75.height,
          const StepNextButton(stepKey: null),
        ],
      ),
    );
  }
}

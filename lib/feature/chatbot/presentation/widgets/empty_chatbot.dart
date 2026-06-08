import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_rich_text.dart';

class EmptyChatbotWidget extends StatelessWidget {
  const EmptyChatbotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: 36.hPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.imagesLuna,
              height: 256.h,
              colorMapper: AppSvgColorMapper(
                from: const Color(0xffFF9BBC),
                to: context.ext.colors.primaryLight,
              ),
            ),
            49.height,

            CustomRichText(
              firstText: context.trContext(TK.chatbotWelcomeFirst),
              secondText: context.trContext(TK.chatbotWelcomeSecond),
              firstTextStyle: context.text.displayLarge!,
              secondTextStyle: context.text.headlineLarge!,
            ),
            21.height,
            Text(
              context.trContext(TK.chatbotHelpPrompt),
              textAlign: TextAlign.center,
              style: context.text.headlineSmall!.copyWith(
                color: context.ext.colors.lightTextPrimary.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

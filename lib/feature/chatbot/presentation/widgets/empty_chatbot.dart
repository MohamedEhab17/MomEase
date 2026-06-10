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

class WavingLunaWidget extends StatefulWidget {
  const WavingLunaWidget({super.key});

  @override
  State<WavingLunaWidget> createState() => _WavingLunaWidgetState();
}

class _WavingLunaWidgetState extends State<WavingLunaWidget>
    with TickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final AnimationController _waveController;
  late final Animation<double> _hoverAnimation;
  late final Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _hoverAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeInOut,
      ),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _waveAnimation = Tween<double>(begin: -0.15, end: 0.15).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.easeInOut,
      ),
    );

    _hoverController.repeat(reverse: true);
    _waveController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapper = AppSvgColorMapper(
      from: const Color(0xffFF9BBC),
      to: context.ext.colors.primaryLight,
    );

    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _hoverAnimation.value),
          child: child,
        );
      },
      child: SizedBox(
        height: 256.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              AppImages.imagesLunaBody,
              height: 256.h,
              colorMapper: mapper,
            ),
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _waveAnimation.value,
                  alignment: const Alignment(-0.375, 0.237),
                  child: child,
                );
              },
              child: SvgPicture.asset(
                AppImages.imagesLunaArm,
                height: 256.h,
                colorMapper: mapper,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            const WavingLunaWidget(),
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

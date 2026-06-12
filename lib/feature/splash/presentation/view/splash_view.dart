import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_font_family.dart';
import 'package:new_mama/core/routers/app_router.dart';
import 'package:new_mama/core/utils/app_images.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;

  // Animations for logo halves (Interval 0.0 - 0.4)
  late Animation<double> _leftSlideOffsetAnim;
  late Animation<double> _rightSlideOffsetAnim;
  late Animation<double> _halvesOpacityAnim;

  // Animations for merged logo pop bounce (Interval 0.4 - 0.65)
  late Animation<double> _mergedScaleAnim;

  // Animations for merging spark (Interval 0.4 - 0.7)
  late Animation<double> _sparkScaleAnim;
  late Animation<double> _sparkOpacityAnim;

  // Animations for background ambient pulse (continuous once merged)
  late Animation<double> _pulseScaleAnim;
  late Animation<double> _pulseOpacityAnim;

  // Animations for staggered text letters (Interval 0.55 - 0.95)
  late List<Animation<double>> _letterAnims;

  final String _appName = "MomEase";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 1. Logo halves slide-in (0.0 to 1.4s)
    _leftSlideOffsetAnim = Tween<double>(begin: -150.w, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _rightSlideOffsetAnim = Tween<double>(begin: 150.w, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _halvesOpacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    // 2. Merged logo pop bounce (1.4s to 2.27s)
    _mergedScaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.15).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.97).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.97, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.65),
      ),
    );

    // 3. Spark burst animation (1.4s to 2.45s)
    _sparkScaleAnim = Tween<double>(begin: 0.2, end: 2.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _sparkOpacityAnim = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    // 4. Ambient breathing pulse
    _pulseScaleAnim = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseOpacityAnim = Tween<double>(begin: 0.4, end: 0.75).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // 5. Staggered letter animations (1.92s to 3.32s)
    _letterAnims = List.generate(_appName.length, (index) {
      final start = 0.55 + (index * 0.05);
      final end = (start + 0.2).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animationController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });

    _animationController.addListener(() {
      if (_animationController.value >= 0.4 && !_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            context.go(
              AppRouter.nextRouteAfterSplash,
              extra: AppRouter.nextRouteExtra,
            );
          }
        });
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = 200.w;
    final bool isMerged = _animationController.value >= 0.4;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0A1B), // Very dark indigo
              Color(0xFF130E26), // Cosmic purple/blue
              Color(0xFF050308), // Near black
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Ambient pulsing glow behind the logo
            if (isMerged)
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _pulseOpacityAnim.value * 0.35,
                    child: Transform.scale(
                      scale: _pulseScaleAnim.value,
                      child: Container(
                        width: 280.w,
                        height: 280.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFF66A1).withAlpha(153), // 0.6 opacity
                              const Color(0xFFA94ACF).withAlpha(76),  // 0.3 opacity
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // 2. Merging spark flash
            if (_animationController.value >= 0.4 && _animationController.value < 0.7)
              Opacity(
                opacity: _sparkOpacityAnim.value,
                child: Transform.scale(
                  scale: _sparkScaleAnim.value,
                  child: Container(
                    width: 320.w,
                    height: 320.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withAlpha(229), // 0.9 opacity
                          const Color(0xFFFFE5EF).withAlpha(102), // 0.4 opacity
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // 3. Logo and Text Content Column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Wrapper
                SizedBox(
                  width: logoSize + 150.w, // Leave room for slide-in animation
                  height: logoSize,
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        if (!isMerged) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            textDirection: TextDirection.ltr,
                            children: [
                              // Left Half
                              Transform.translate(
                                offset: Offset(_leftSlideOffsetAnim.value, 0),
                                child: Opacity(
                                  opacity: _halvesOpacityAnim.value,
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.5,
                                      child: SvgPicture.asset(
                                        AppImages.momeaseSvgLogo,
                                        width: logoSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Right Half
                              Transform.translate(
                                offset: Offset(_rightSlideOffsetAnim.value, 0),
                                child: Opacity(
                                  opacity: _halvesOpacityAnim.value,
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      widthFactor: 0.5,
                                      child: SvgPicture.asset(
                                        AppImages.momeaseSvgLogo,
                                        width: logoSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Merged Full Logo (with pop + breathing animation)
                          double logoScale = 1.0;
                          if (_animationController.value < 0.65) {
                            logoScale = _mergedScaleAnim.value;
                          } else {
                            logoScale = 0.985 + (_pulseController.value * 0.03);
                          }
                          return Transform.scale(
                            scale: logoScale,
                            child: SvgPicture.asset(
                              AppImages.momeaseSvgLogo,
                              width: logoSize,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // 4. Word "MomEase" Letter by Letter Staggered Entrance
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFFF8CB8), // Primary Light
                      Color(0xFFFF3381), // Primary Dark
                      Color(0xFFA94ACF), // Gradient Purple
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.ltr,
                    children: List.generate(_appName.length, (index) {
                      final char = _appName[index];
                      final animation = _letterAnims[index];

                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          // Slide up from 20px below to 0px
                          final double slideOffsetY = (1.0 - animation.value) * 20.h;
                          return Transform.translate(
                            offset: Offset(0, slideOffsetY),
                            child: Opacity(
                              opacity: animation.value.clamp(0.0, 1.0),
                              child: Text(
                                char,
                                style: TextStyle(
                                  fontSize: 42.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFontFamily.scriptMT,
                                  color: Colors.white, // Color is overridden by ShaderMask
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

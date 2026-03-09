import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class LoveActionButton extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isLiked;

  const LoveActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLiked = false,
  });

  @override
  State<LoveActionButton> createState() => _LoveActionButtonState();
}

class _LoveActionButtonState extends State<LoveActionButton>
    with TickerProviderStateMixin {
  late bool _isLiked;

  late AnimationController _popController;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Floating heart animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void _handleTap() {
    widget.onTap();

    // Pop effect
    _popController.forward().then((_) => _popController.reverse());

    // Floating heart only when liking
    if (!_isLiked) {
      _floatingController.forward(from: 0);
    }

    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [

        /// Floating Heart
        AnimatedBuilder(
          animation: _floatingController,
          builder: (_, _) {
            return Positioned(
              top: -10 - (_floatingController.value * 40),
              child: Opacity(
                opacity: 1 - _floatingController.value,
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: 14 + (_floatingController.value * 10),
                ),
              ),
            );
          },
        ),

        /// Main Button
        GestureDetector(
          onTap: _handleTap,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.08).animate(
              CurvedAnimation(
                parent: _popController,
                curve: Curves.easeOut,
              ),
            ),
            child: Container(
              width: 113.w,
              height: 30.h,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: _isLiked
                    ? AppColors.primaryDark.withAlpha(77)
                    : AppColors.primaryLighter.withAlpha(77),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    _isLiked ? widget.icon : widget.icon,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.label,
                    style: AppStyles.styleInter12.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _popController.dispose();
    _floatingController.dispose();
    super.dispose();
  }
}
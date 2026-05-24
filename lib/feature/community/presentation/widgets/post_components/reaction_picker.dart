import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

/// Reaction types supported by the backend.
class ReactionConfig {
  final String type;
  final IconData icon;
  final Color color;
  final String emoji;

  const ReactionConfig({
    required this.type,
    required this.icon,
    required this.color,
    required this.emoji,
  });

  static const List<ReactionConfig> all = [
    ReactionConfig(
      type: 'LIKE',
      icon: Icons.thumb_up_rounded,
      color: Color(0xFF4C8DFF),
      emoji: '👍',
    ),
    ReactionConfig(
      type: 'LOVE',
      icon: Icons.favorite_rounded,
      color: Color(0xFFFF4D6D),
      emoji: '❤️',
    ),
    ReactionConfig(
      type: 'SUPPORT',
      icon: Icons.volunteer_activism_rounded,
      color: Color(0xFFFF9500),
      emoji: '🤗',
    ),
    ReactionConfig(
      type: 'HELPFUL',
      icon: Icons.lightbulb_rounded,
      color: Color(0xFFFFCC00),
      emoji: '💡',
    ),
  ];

  static ReactionConfig? byType(String? type) {
    if (type == null) return null;
    try {
      return all.firstWhere((r) => r.type == type);
    } catch (_) {
      return null;
    }
  }
}

/// Shows the reaction picker as an overlay near the tapped button.
class ReactionPickerOverlay extends StatefulWidget {
  final Function(String) onReactionSelected;

  const ReactionPickerOverlay({super.key, required this.onReactionSelected});

  @override
  State<ReactionPickerOverlay> createState() => _ReactionPickerOverlayState();

  static Future<void> show(
    BuildContext context,
    Offset buttonOffset,
    Function(String) onReactionSelected,
  ) {
    HapticFeedback.lightImpact();
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'Reaction Picker',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => Stack(
        children: [
          Positioned(
            left: buttonOffset.dx.clamp(8, MediaQuery.of(context).size.width - 220),
            top: (buttonOffset.dy - 70.h).clamp(8, double.infinity),
            child: ReactionPickerOverlay(onReactionSelected: onReactionSelected),
          ),
        ],
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }
}

class _ReactionPickerOverlayState extends State<ReactionPickerOverlay>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scales;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      ReactionConfig.all.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150 + i * 30),
      ),
    );
    _scales = _controllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: c, curve: Curves.elasticOut),
            ))
        .toList();

    // Stagger the entrance
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 40), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(ReactionConfig.all.length, (i) {
            final reaction = ReactionConfig.all[i];
            final isHovered = _hoveredIndex == i;

            return ScaleTransition(
              scale: _scales[i],
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = i),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                    widget.onReactionSelected(reaction.type);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.all(isHovered ? 10.r : 6.r),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? reaction.color.withAlpha(38)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AnimatedScale(
                      scale: isHovered ? 1.3 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            reaction.icon,
                            color: reaction.color,
                            size: isHovered ? 30.sp : 24.sp,
                          ),
                          if (isHovered) ...[
                            SizedBox(height: 2.h),
                            Text(
                              reaction.type[0] +
                                  reaction.type.substring(1).toLowerCase(),
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: reaction.color,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

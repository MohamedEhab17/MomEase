import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reaction_picker.dart';
import 'burst_particles.dart';

class ReactionButton extends StatefulWidget {
  final PostModel post;
  const ReactionButton({super.key, required this.post});

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _burstCtrl;
  late final Animation<double> _burstScale;
  late final Animation<double> _burstOpacity;

  @override
  void initState() {
    super.initState();
    _burstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _burstScale = Tween<double>(begin: 0.5, end: 1.6).animate(
      CurvedAnimation(parent: _burstCtrl, curve: Curves.easeOutBack),
    );
    _burstOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _burstCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _burstCtrl.dispose();
    super.dispose();
  }

  void _triggerBurst() {
    _burstCtrl.forward(from: 0);
  }

  void _onTap(BuildContext context) {
    HapticFeedback.selectionClick();
    if (widget.post.myReaction == null) _triggerBurst();
    context.read<CommunityCubit>().toggleReaction(
          postId: widget.post.postId,
          reactionType: widget.post.myReaction ?? 'LOVE',
        );
  }

  void _onLongPress(BuildContext context) {
    HapticFeedback.mediumImpact();
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero);
    ReactionPickerOverlay.show(context, offset, (type) {
      _triggerBurst();
      context.read<CommunityCubit>().toggleReaction(
            postId: widget.post.postId,
            reactionType: type,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final reaction = ReactionConfig.byType(widget.post.myReaction);
    final isActive = reaction != null;
    final activeColor = reaction?.color ?? context.ext.colors.primaryDark;

    return GestureDetector(
      onTap: () => _onTap(context),
      onLongPress: () => _onLongPress(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Burst ring
          AnimatedBuilder(
            animation: _burstCtrl,
            builder: (_, _) => _burstCtrl.value == 0
                ? const SizedBox.shrink()
                : Opacity(
                    opacity: _burstOpacity.value,
                    child: BurstParticles(
                      color: activeColor,
                      scale: _burstScale.value,
                    ),
                  ),
          ),
          // Pill Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 113.w,
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withAlpha(31)
                  : context.ext.colors.primaryLighter.withAlpha(77),
              borderRadius: BorderRadius.circular(16),
              border: isActive
                  ? Border.all(color: activeColor.withAlpha(76), width: 1)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.elasticOut,
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: child,
                  ),
                  child: reaction != null
                      ? Icon(
                          key: ValueKey(reaction.type),
                          reaction.icon,
                          color: activeColor,
                          size: 16.sp,
                        )
                      : SvgPicture.asset(
                          key: const ValueKey('unfilled'),
                          AppIcons.iconsUnfilledLike,
                          width: 16.w,
                          height: 16.h,
                          colorMapper: AppSvgColorMapper(
                            from: const Color(0xffFF3381),
                            to: context.ext.colors.primaryDark,
                          ),
                        ),
                ),
                6.width,
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: context.text.bodyMedium!.copyWith(
                    color: isActive ? activeColor : context.ext.colors.primaryDark,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                  child: Text(
                    reaction != null
                        ? _getLocalizedReaction(context, reaction.type)
                        : (context.isAr ? 'إعجاب' : 'Like'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedReaction(BuildContext context, String type) {
    if (context.isAr) {
      switch (type) {
        case 'LIKE': return 'إعجاب';
        case 'LOVE': return 'أحببته';
        case 'SUPPORT': return 'دعم';
        case 'HELPFUL': return 'مفيد';
        default: return type;
      }
    }
    return type[0] + type.substring(1).toLowerCase();
  }
}

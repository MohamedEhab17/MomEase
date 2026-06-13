import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class OverlayMenuItem<T> {
  final IconData icon;
  final String text;
  final T value;

  const OverlayMenuItem({
    required this.icon,
    required this.text,
    required this.value,
  });
}

typedef MenuTargetBuilder =
    Widget Function(BuildContext context, VoidCallback showMenu);

class CustomOverlayMenu<T> extends StatefulWidget {
  final MenuTargetBuilder builder;
  final List<OverlayMenuItem<T>> items;
  final ValueChanged<T> onItemSelected;

  const CustomOverlayMenu({
    super.key,
    required this.builder,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<CustomOverlayMenu<T>> createState() => _CustomOverlayMenuState<T>();
}

class _CustomOverlayMenuState<T> extends State<CustomOverlayMenu<T>>
    with SingleTickerProviderStateMixin {
  late final LayerLink _layerLink;
  OverlayEntry? _overlayEntry;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void _showMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
    } else {
      _closeMenu();
    }
  }

  void _closeMenu() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  OverlayEntry _createOverlay() {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: _closeMenu,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: isRTL
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              followerAnchor: isRTL ? Alignment.topLeft : Alignment.topRight,
              offset: isRTL ? const Offset(2, 2) : const Offset(-2, 2),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
                  child: _buildMenu(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: 20.vPadding,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.ext.colors.primaryLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          spacing: 20,
          children: widget.items.map((item) => _menuItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _menuItem(OverlayMenuItem<T> item) {
    return InkWell(
      onTap: () {
        widget.onItemSelected(item.value);
        _closeMenu();
      },
      child: Padding(
        padding: 12.hPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          spacing: 12,
          children: [
            Icon(item.icon, size: 20, color: context.colors.onSurface),
            Text(
              item.text,
              style: context.text.titleLarge!.copyWith(fontWeight: .w600),
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.builder(context, _showMenu),
    );
  }
}

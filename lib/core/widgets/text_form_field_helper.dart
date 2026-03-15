import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class TextFormFieldHelper extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword, isVisible;
  final String? hint, obscuringCharacter, labelText, label;
  final bool enabled;
  final int? maxLines, minLines, maxLength;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onChanged, onFieldSubmitted, onSaved;
  final void Function()? onEditingComplete, onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget, prefixIcon, prefix;
  final IconData? icon;
  final TextInputAction? action;
  final FocusNode? focusNode;

  final BorderRadius? borderRadius;
  final bool? isMobile;
  final bool? isReadOnly;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final Color? fillColor;

  final bool enableShadow;

  const TextFormFieldHelper({
    super.key,
    this.controller,
    this.isPassword = false,
    this.isVisible = false,
    this.hint,
    this.label,
    this.labelText,
    this.enabled = true,
    this.obscuringCharacter,
    this.onValidate,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onSaved,
    this.onTap,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.suffixWidget,
    this.icon,
    this.prefixIcon,
    this.prefix,
    this.action,
    this.focusNode,
    this.borderRadius,
    this.isMobile,
    this.hintStyle,
    this.borderColor,
    this.fillColor = AppColors.primaryTint,
    this.isReadOnly,
    this.enableShadow = true,
  });

  @override
  State<TextFormFieldHelper> createState() => _TextFormFieldHelperState();
}

class _TextFormFieldHelperState extends State<TextFormFieldHelper> {
  late bool obscureText;
  TextDirection _textDirection = TextDirection.ltr;

  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() => obscureText = !obscureText);
  }

  void _updateTextDirection(String text) {
    if (text.isEmpty) return;
    final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(text);
    setState(() {
      _textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  String? _validator(String? value) {
    final result = widget.onValidate?.call(value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _hasError != (result != null)) {
        setState(() {
          _hasError = result != null;
        });
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8.r);

    final showShadow = widget.enableShadow && !_hasError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(visible: widget.isVisible, child: Text(widget.label ?? "")),

        Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          elevation: showShadow ? 6 : 0,
          shadowColor: AppColors.lightTextPrimary.withAlpha(26),
          child: TextFormField(
            controller: widget.controller,
            validator: _validator,
            onChanged: (text) {
              widget.onChanged?.call(text);
              _updateTextDirection(text);
            },
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            onSaved: widget.onSaved,
            onTap: widget.onTap,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            obscureText: obscureText,
            obscuringCharacter: widget.obscuringCharacter ?? '*',
            cursorColor: AppColors.primary,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            textInputAction: widget.action ?? TextInputAction.next,
            focusNode: widget.focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textAlign: widget.isMobile != null
                ? TextAlign.left
                : TextAlign.start,
            textDirection: widget.isMobile != null
                ? TextDirection.ltr
                : _textDirection,
            readOnly: widget.isReadOnly ?? false,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              fillColor: widget.fillColor,
              filled: true,
              hintText: widget.hint,
              hintStyle:
                  widget.hintStyle ??
                  AppStyles.styleRoboto12.copyWith(fontWeight: FontWeight.w400),
              errorMaxLines: 4,
              errorStyle: const TextStyle(color: Colors.red),
              prefixIcon: widget.prefixIcon,
              prefix: widget.prefix,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: _toggleObscureText,
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.lightTextDisabled,
                      ),
                    )
                  : widget.suffixWidget,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 19,
              ),
              border: outlineInputBorder(
                color: widget.borderColor ?? AppColors.primaryExtraLight,
                width: 1,
              ),
              enabledBorder: outlineInputBorder(
                color: widget.borderColor ?? AppColors.primaryExtraLight,
                width: 1,
              ),
              focusedBorder: outlineInputBorder(
                color: widget.borderColor ?? AppColors.primaryDark,
                width: 1,
              ),
              errorBorder: outlineInputBorder(color: Colors.red, width: 1),
              focusedErrorBorder: outlineInputBorder(
                color: Colors.red,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

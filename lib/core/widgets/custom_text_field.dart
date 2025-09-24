import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final bool showErrorBorder;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.showErrorBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(
              fontSize: AppConstants.defaultFontSize,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultRadius),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          autofocus: autofocus,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: AppConstants.defaultFontSize,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor ?? AppColors.white,
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.defaultPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultRadius),
              borderSide: BorderSide(color: borderColor ?? AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultRadius),
              borderSide: BorderSide(color: borderColor ?? AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultRadius),
              borderSide: BorderSide(
                color: focusedBorderColor ?? AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: showErrorBorder ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ) : null,
            focusedErrorBorder: showErrorBorder ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultRadius),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ) : null,
            counterText: maxLength != null ? null : '',
          ),
        ),
        ),
      ],
    );
  }
}

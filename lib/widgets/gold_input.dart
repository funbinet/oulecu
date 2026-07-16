import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GoldInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;

  const GoldInput({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      focusNode: focusNode,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontFamily: 'JetBrainsMono',
      ),
      cursorColor: AppColors.primaryGold,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}

class GoldTextArea extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int maxLines;
  final int? maxLength;
  final Widget? suffix;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;

  const GoldTextArea({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.maxLines = 8,
    this.maxLength,
    this.suffix,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontFamily: 'JetBrainsMono',
        height: 1.6,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontStyle: fontStyle ?? FontStyle.normal,
      ),
      cursorColor: AppColors.primaryGold,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        suffixIcon: suffix,
      ),
    );
  }
}

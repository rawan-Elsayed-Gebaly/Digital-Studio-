import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constrants/colors.dart';

class CourseFormField extends StatelessWidget {
  const CourseFormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.prefix,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          cursorColor: AppColors.primary,
          style: const TextStyle(color: AppColors.text, fontSize: 14),
          decoration: courseInputDecoration(hint: hint, prefix: prefix),
        ),
      ],
    );
  }
}

InputDecoration courseInputDecoration({String? hint, Widget? prefix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.hint, fontSize: 13),
    prefixIcon: prefix,
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
    ),
  );
}

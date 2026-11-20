import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';

class PasswordVisibilityIcon extends StatelessWidget {
  const PasswordVisibilityIcon({
    required this.obscureText,
    required this.onPressed,
    super.key,
  });

  final bool obscureText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: AppColors.muted,
        size: 20,
      ),
    );
  }
}

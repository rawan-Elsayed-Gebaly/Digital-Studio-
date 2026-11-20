import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import 'auth_primary_button.dart';
import 'auth_toggle.dart';
import 'field_label.dart';
import 'outlined_text_filed.dart';
import 'password_visibility_icon.dart';

class AuthPanel extends StatelessWidget {
  const AuthPanel({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onTogglePassword,
    required this.onRememberChanged,
    required this.onRegisterTap,
    required this.onLoginPressed,
    super.key,
  });

  final TextEditingController emailController; // Added
  final TextEditingController passwordController; // Added
  final bool obscurePassword;
  final bool rememberMe;
  final VoidCallback onTogglePassword;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome to lorem.i',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        AuthToggle(
          isLoginSelected: true,
          onLoginTap: () {},
          onRegisterTap: onRegisterTap,
        ),
        const SizedBox(height: 28),
        const Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.45),
        ),
        const SizedBox(height: 28),
        const FieldLabel('Email'),
        const SizedBox(height: 8),
        OutlinedTextField(
          controller: emailController,
          hint: 'Enter your User email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        const FieldLabel('Password'),
        const SizedBox(height: 8),
        OutlinedTextField(
          controller: passwordController,
          hint: 'Enter your Password',
          obscureText: obscurePassword,
          suffix: PasswordVisibilityIcon(
            obscureText: obscurePassword,
            onPressed: onTogglePassword,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: rememberMe,
                onChanged: (value) => onRememberChanged(value ?? false),
                side: const BorderSide(color: AppColors.border),
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'remember me',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.muted,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Forgot Password ?',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        AuthPrimaryButton(label: 'Login', onPressed: onLoginPressed),
      ],
    );
  }
}

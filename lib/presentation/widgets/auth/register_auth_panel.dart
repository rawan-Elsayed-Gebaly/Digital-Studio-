import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import 'auth_primary_button.dart';
import 'auth_toggle.dart';
import 'field_label.dart';
import 'outlined_text_filed.dart';
import 'password_visibility_icon.dart';

class RegisterAuthPanel extends StatelessWidget {
  const RegisterAuthPanel({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onLoginTap,
    required this.onRegisterPressed,
    super.key,

  });

  final TextEditingController emailController; // Added
  final TextEditingController passwordController; // Added
  final TextEditingController confirmPasswordController; // Added
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterPressed;

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
          isLoginSelected: false,
          onLoginTap: onLoginTap,
          onRegisterTap: () {},
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
          hint: 'Enter your Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        const FieldLabel('Password'),
        const SizedBox(height: 8),
        OutlinedTextField(
          controller: passwordController ,
          hint: 'Enter your Password',
          obscureText: obscurePassword,
          suffix: PasswordVisibilityIcon(
            obscureText: obscurePassword,
            onPressed: onTogglePassword,
          ),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Confirm Password'),
        const SizedBox(height: 8),
        OutlinedTextField(
          controller: confirmPasswordController,
          hint: 'Confirm your Password',
          obscureText: obscureConfirmPassword,
          suffix: PasswordVisibilityIcon(
            obscureText: obscureConfirmPassword,
            onPressed: onToggleConfirmPassword,
          ),
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onLoginTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.muted,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Login ?', style: TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(height: 28),
        AuthPrimaryButton(label: 'Register', onPressed: onRegisterPressed),
      ],
    );
  }
}

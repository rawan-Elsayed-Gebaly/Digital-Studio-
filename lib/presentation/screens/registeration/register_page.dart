import 'package:business_managment_system/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../widgets/auth/auth_layout.dart';
import '../../widgets/auth/register_auth_panel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false; // 1. Track loading state

  // 1. Declare the controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _openLoginPage() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // 2. Always clean up controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return; // Prevent multiple clicks
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _isLoading = true); // 2. Start loading
    try {
      // 3. Call register service with extracted values
      await _authService.register(email, password);

      if (!mounted) return;
      // Handle success (e.g., navigate or show success message)
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }finally {
      if (mounted) {
        setState(() => _isLoading = false); // 3. Stop loading
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      form: RegisterAuthPanel(
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        obscurePassword: _obscurePassword,
        obscureConfirmPassword: _obscureConfirmPassword,
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onToggleConfirmPassword: () =>
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        onLoginTap: _openLoginPage,
        // Pass loading state to disable button or show a progress indicator if your button supports it
        onRegisterPressed: _isLoading ? () {} : _handleRegister,
      ),
    );
  }
}

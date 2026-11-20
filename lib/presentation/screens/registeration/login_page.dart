import 'package:flutter/material.dart';

import '../../../service/auth_service.dart';
import '../../widgets/auth/auth_layout.dart';
import '../../widgets/auth/auth_panel.dart';
import '../dashboard/dashboard_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false; // 1. Track loading state

  // 1. Declare the controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _openRegisterPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  @override
  void dispose() {
    // 2. Always clean up controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handelLogIn() async {
    if (_isLoading) return; // Prevent multiple clicks
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    setState(() => _isLoading = true); // 2. Start loading

    try {
      // 3. Call login service with extracted values
      final success = await _authService.login(email, password);

      if (!mounted) return;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // 3. Stop loading
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      form: AuthPanel(
        emailController: _emailController,
        passwordController: _passwordController,
        obscurePassword: _obscurePassword,
        rememberMe: _rememberMe,
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onRememberChanged: (value) => setState(() => _rememberMe = value),
        onRegisterTap: _openRegisterPage,
        onLoginPressed: _handelLogIn,
      ),
    );
  }
}

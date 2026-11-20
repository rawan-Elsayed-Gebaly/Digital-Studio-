import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import 'auth_tab_button.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({
    required this.isLoginSelected,
    required this.onLoginTap,
    required this.onRegisterTap,
    super.key,
  });

  final bool isLoginSelected;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.toggleTrack,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            AuthTabButton(
              label: 'Login',
              selected: isLoginSelected,
              onTap: onLoginTap,
            ),
            AuthTabButton(
              label: 'Register',
              selected: !isLoginSelected,
              onTap: onRegisterTap,
            ),
          ],
        ),
      ),
    );
  }
}

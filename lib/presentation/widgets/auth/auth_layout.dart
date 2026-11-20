import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import 'login_hero_panel.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({required this.form, super.key});

  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final pagePadding = EdgeInsets.symmetric(
              horizontal: isWide ? 56 : 24,
              vertical: isWide ? 40 : 24,
            );

            if (!isWide) {
              return SingleChildScrollView(
                padding: pagePadding,
                child: Column(
                  children: [
                    const LoginHeroPanel(height: 280),
                    const SizedBox(height: 32),
                    form,
                  ],
                ),
              );
            }

            return Padding(
              padding: pagePadding,
              child: Row(
                children: [
                  const Expanded(child: LoginHeroPanel()),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: form,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

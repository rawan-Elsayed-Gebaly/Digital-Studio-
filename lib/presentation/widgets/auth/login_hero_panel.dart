import 'package:flutter/material.dart';

class LoginHeroPanel extends StatelessWidget {
  const LoginHeroPanel({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          'assets/login_hero.jpeg',
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.15),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 18, 28, 8),
      child: Row(
        children: [
          Spacer(),
          Icon(Icons.notifications_none, color: AppColors.text),
          SizedBox(width: 16),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.navy,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          SizedBox(width: 8),
          Text(
            'Admin',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
        ],
      ),
    );
  }
}

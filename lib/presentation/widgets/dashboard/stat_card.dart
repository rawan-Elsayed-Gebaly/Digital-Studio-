import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../screens/dashboard/dashboard_data.dart';
import 'dashboard_card.dart';

class StatCard extends StatelessWidget {
  const StatCard({required this.item, super.key});

  final StatItem item;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: item.color.withValues(alpha: 0.14),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                item.isUp ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: item.isUp ? AppColors.students : AppColors.danger,
              ),
              const SizedBox(width: 4),
              Text(
                item.change,
                style: TextStyle(
                  color: item.isUp ? AppColors.students : AppColors.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  item.changeLabel,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

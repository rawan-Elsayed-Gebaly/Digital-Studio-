import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../screens/dashboard/dashboard_data.dart';
import 'dashboard_card.dart';
import 'section_header.dart';
import 'status_chip.dart';

class PopularCourses extends StatelessWidget {
  const PopularCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          const SectionHeader(title: 'Popular Courses', actionLabel: 'View all'),
          const SizedBox(height: 8),
          for (final course in DashboardData.popularCourses)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: course.color.withValues(alpha: 0.14),
                    child: Icon(course.icon, color: course.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          course.students,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StatusChip(label: 'Active'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

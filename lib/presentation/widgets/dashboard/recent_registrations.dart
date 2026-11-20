import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../screens/dashboard/dashboard_data.dart';
import 'dashboard_card.dart';
import 'section_header.dart';
import 'status_chip.dart';

class RecentRegistrations extends StatelessWidget {
  const RecentRegistrations({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Recent Registrations',
            actionLabel: 'View all',
          ),
          const SizedBox(height: 16),
          const _TableHeader(),
          const Divider(height: 24, color: AppColors.border),
          for (final item in DashboardData.registrations) _RegistrationRow(item: item),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: AppColors.muted,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
    return const Row(
      children: [
        Expanded(flex: 3, child: Text('Student', style: style)),
        Expanded(flex: 2, child: Text('Course', style: style)),
        Expanded(child: Text('Date', style: style)),
        Expanded(child: Text('Status', style: style)),
        SizedBox(width: 24),
      ],
    );
  }
}

class _RegistrationRow extends StatelessWidget {
  const _RegistrationRow({required this.item});

  final RegistrationItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.navy,
                  child: Text(
                    item.name[0],
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        item.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.course,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.text, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              item.date,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
          Expanded(child: StatusChip(label: item.status)),
          const Icon(Icons.more_vert, size: 18, color: AppColors.muted),
        ],
      ),
    );
  }
}

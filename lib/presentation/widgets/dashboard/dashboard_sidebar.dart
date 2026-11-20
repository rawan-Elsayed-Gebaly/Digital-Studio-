import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedIndex,
    this.onItemTap,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int>? onItemTap;

  static const _items = [
    (Icons.home_outlined, 'Dashboard'),
    (Icons.menu_book_outlined, 'Courses'),
    (Icons.groups_outlined, 'Students'),
    (Icons.assignment_outlined, 'Registrations'),
    (Icons.calendar_month_outlined, 'Schedule'),
    (Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.school, color: Colors.white, size: 20),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CourseAcademy',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Learn • Grow • Succeed',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF9BB0C9), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Expanded(
            child: ListView(
              children: [
                for (var i = 0; i < _items.length; i++)
                  _NavItem(
                    icon: _items[i].$1,
                    label: _items[i].$2,
                    selected: i == selectedIndex,
                    onTap: onItemTap == null ? null : () => onItemTap!(i),
                  ),
              ],
            ),
          ),
          const _NavItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            selected: false,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.navySelected : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: selected ? 1 : 0.78),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

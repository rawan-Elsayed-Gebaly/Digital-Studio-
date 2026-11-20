import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../../model/Course.dart';
import '../dashboard/status_chip.dart';

class CoursesTable extends StatelessWidget {
  const CoursesTable({
    required this.courses,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final List<Course> courses;
  final ValueChanged<Course>? onEdit;
  final ValueChanged<Course>? onDelete;



  static const _headerStyle = TextStyle(
    color: AppColors.muted,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No courses found',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFF7F9FC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: const Row(
            children: [
              SizedBox(width: 52, child: Text('Poster', style: _headerStyle)),
              Expanded(flex: 3, child: Text('Name', style: _headerStyle)),
              Expanded(flex: 2, child: Text('Instructor', style: _headerStyle)),
              Expanded(child: Text('Duration', style: _headerStyle)),
              Expanded(child: Text('Price', style: _headerStyle)),
              Expanded(child: Text('Available Seats', style: _headerStyle)),
              Expanded(child: Text('Status', style: _headerStyle)),
              SizedBox(width: 88, child: Text('Actions', style: _headerStyle)),
            ],
          ),
        ),
        for (var i = 0; i < courses.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.border),
          _CourseRow(course: courses[i], onEdit: onEdit, onDelete: onDelete),
        ],
      ],
    );
  }
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({required this.course, this.onEdit, this.onDelete});

  final Course course;
  final ValueChanged<Course>? onEdit;
  final ValueChanged<Course>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(width: 52, child: _Poster(course: course)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (course.description.isNotEmpty)
                    Text(
                      course.description,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              course.instructor,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.text, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              course.duration,
              style: const TextStyle(color: AppColors.text, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              _formatPrice(course.price),
              style: const TextStyle(color: AppColors.text, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              '${course.capacity}',
              style: const TextStyle(color: AppColors.text, fontSize: 13),
            ),
          ),
          Expanded(child: StatusChip(label: course.status)),
          SizedBox(
            width: 88,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onEdit == null ? null : () => onEdit!(course),
                  tooltip: 'Edit',
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  color: AppColors.primary,
                ),
                IconButton(
                  onPressed: onDelete == null ? null : () => onDelete!(course),
                  tooltip: 'Delete',
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: AppColors.danger,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final color = _posterColor(course.name);
    final imageUrl = course.posterUrl.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        color: color.withValues(alpha: 0.14),
        child: imageUrl.isEmpty
            ? Icon(_posterIcon(course.name), color: color, size: 20)
            : Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              Icon(_posterIcon(course.name), color: color, size: 20),
        ),
      ),
    );
  }
}

IconData _posterIcon(String name) {
  final value = name.toLowerCase();
  if (value.contains('flutter')) return Icons.flash_on_outlined;
  if (value.contains('python')) return Icons.code;
  if (value.contains('design')) return Icons.dashboard_customize_outlined;
  if (value.contains('data')) return Icons.bar_chart_rounded;
  if (value.contains('web')) return Icons.terminal;
  if (value.contains('database')) return Icons.storage_outlined;
  return Icons.menu_book_outlined;
}

Color _posterColor(String name) {
  const palette = [
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFF0EA5E9),
  ];
  return palette[name.hashCode.abs() % palette.length];
}

String _formatPrice(double price) {
  final digits = price.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return 'EGP $buffer';
}


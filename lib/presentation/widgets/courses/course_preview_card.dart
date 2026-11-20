import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../dashboard/status_chip.dart';
import 'course_poster_picker.dart';

class CoursePreviewCard extends StatelessWidget {
  const CoursePreviewCard({
    required this.name,
    required this.instructor,
    required this.duration,
    required this.price,
    required this.capacity,
    required this.status,
    this.imageBytes,
    this.imageUrl,
    super.key,
  });

  final String name;
  final String instructor;
  final String duration;
  final String price;
  final String capacity;
  final String status;
  final Uint8List? imageBytes;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      icon: Icons.visibility_outlined,
      title: 'Preview',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Thumb(imageBytes: imageBytes, imageUrl: imageUrl, name: name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? 'Course name' : name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        instructor.isEmpty ? 'Instructor' : instructor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _Meta(icon: Icons.calendar_today_outlined, text: duration.isEmpty ? 'Duration' : duration),
                _Meta(
                  icon: Icons.payments_outlined,
                  text: price.isEmpty ? 'EGP 0' : price,
                ),
                _Meta(
                  icon: Icons.people_outline,
                  text: capacity.isEmpty ? '0 seats' : '$capacity seats',
                ),
                StatusChip(label: status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.imageBytes,
    required this.imageUrl,
    required this.name,
  });

  final Uint8List? imageBytes;
  final String? imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 52,
        height: 52,
        color: AppColors.primary.withValues(alpha: 0.12),
        child: imageBytes != null
            ? Image.memory(imageBytes!, fit: BoxFit.cover)
            : url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.menu_book_outlined,
                  color: AppColors.primary,
                ),
              )
            : const Icon(Icons.menu_book_outlined, color: AppColors.primary),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.muted),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: AppColors.text, fontSize: 12),
        ),
      ],
    );
  }
}

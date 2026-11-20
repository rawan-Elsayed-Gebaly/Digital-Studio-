import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';

class CoursePosterPicker extends StatelessWidget {
  const CoursePosterPicker({
    required this.onChooseImage,
    this.imageBytes,
    this.existingImageUrl,
    this.showImagePreview = true,
    super.key,
  });

  final Uint8List? imageBytes;
  final String? existingImageUrl;
  final VoidCallback onChooseImage;
  final bool showImagePreview;

  bool get _hasImage {
    final url = existingImageUrl?.trim() ?? '';
    return imageBytes != null || url.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final chooseLabel = _hasImage ? 'Change Image' : 'Choose Image';

    return Column(
      children: [
        DashboardSectionCard(
          icon: Icons.image_outlined,
          title: 'Course Poster',
          child: Column(
            children: [
              if (_hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: InkWell(
                      onTap: onChooseImage,
                      child: imageBytes != null
                          ? Image.memory(
                              imageBytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.network(
                              existingImageUrl!.trim(),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, _, _) => _EmptyPoster(
                                onTap: onChooseImage,
                              ),
                            ),
                    ),
                  ),
                )
              else
                CustomPaint(
                  painter: _DashedRRectPainter(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                  child: InkWell(
                    onTap: onChooseImage,
                    borderRadius: BorderRadius.circular(16),
                    child: const _UploadHint(),
                  ),
                ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: OutlinedButton.icon(
                  onPressed: onChooseImage,
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: Text(chooseLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showImagePreview) ...[
          const SizedBox(height: 16),
          DashboardSectionCard(
            icon: Icons.visibility_outlined,
            title: 'Preview',
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageBytes == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 42,
                          color: Color(0xFFB7C6E0),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No image selected',
                          style: TextStyle(color: AppColors.muted, fontSize: 13),
                        ),
                      ],
                    )
                  : Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _UploadHint extends StatelessWidget {
  const _UploadHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Drag and drop an image here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'or click to browse',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Recommended size: 600 x 400 px (JPG, PNG)\nMax size: 5 MB',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPoster extends StatelessWidget {
  const _EmptyPoster({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF4F8FF),
      child: InkWell(
        onTap: onTap,
        child: const Center(
          child: Icon(Icons.image_outlined, size: 42, color: Color(0xFFB7C6E0)),
        ),
      ),
    );
  }
}

class DashboardSectionCard extends StatelessWidget {
  const DashboardSectionCard({
    required this.icon,
    required this.title,
    required this.child,
    super.key,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0B1C33),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.text),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(16),
        ),
      );
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../screens/dashboard/dashboard_data.dart';
import 'dashboard_card.dart';
import 'section_header.dart';

class EnrollmentChart extends StatelessWidget {
  const EnrollmentChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Enrollment Overview',
            subtitle: 'New student registrations over the last 4 weeks',
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(painter: _LineChartPainter()),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const values = DashboardData.enrollmentValues;
    const labels = DashboardData.enrollmentLabels;
    const maxY = 40.0;
    const leftPad = 28.0;
    const bottomPad = 28.0;
    final chart = Rect.fromLTWH(leftPad, 8, size.width - leftPad, size.height - bottomPad - 8);

    final gridPaint = Paint()
      ..color = const Color(0xFFE8EDF5)
      ..strokeWidth = 1;

    final labelStyle = TextStyle(color: AppColors.muted, fontSize: 11);

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - (chart.height * i / 4);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _text(canvas, '${i * 10}', Offset(0, y - 7), labelStyle);
    }

    final stepX = chart.width / (values.length - 1);
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      points.add(
        Offset(chart.left + stepX * i, chart.bottom - (values[i] / maxY) * chart.height),
      );
    }

    final fill = Path()
      ..addPolygon([Offset(points.first.dx, chart.bottom), ...points, Offset(points.last.dx, chart.bottom)], true);
    canvas.drawPath(
      fill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x662B6DE8), Color(0x002B6DE8)],
        ).createShader(chart),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final dotFill = Paint()..color = Colors.white;
    final dotStroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (final point in points) {
      canvas.drawCircle(point, 4.5, dotFill);
      canvas.drawCircle(point, 4.5, dotStroke);
    }

    for (var i = 0; i < labels.length; i++) {
      final x = chart.left + (chart.width / (labels.length - 1)) * i;
      _text(canvas, labels[i], Offset(x - 18, size.height - 18), labelStyle);
    }
  }

  void _text(Canvas canvas, String value, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

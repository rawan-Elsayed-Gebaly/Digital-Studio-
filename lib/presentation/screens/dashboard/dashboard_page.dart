import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../widgets/dashboard/courses_donut.dart';
import '../courses/courses_page.dart';
import '../../widgets/dashboard/dashboard_right_panel.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../../widgets/dashboard/enrollment_chart.dart';
import '../../widgets/dashboard/popular_courses.dart';
import '../../widgets/dashboard/recent_registrations.dart';
import '../../widgets/dashboard/stat_card.dart';
import 'dashboard_data.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Row(
        children: [
          DashboardSidebar(
            selectedIndex: 0,
            onItemTap: (index) {
              if (index != 1) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const CoursesPage()),
              );
            },
          ),
          const Expanded(
            child: Column(
              children: [
                DashboardTopBar(),
                Expanded(child: _DashboardBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showRightPanel = constraints.maxWidth >= 1100;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _MainColumn()),
              if (showRightPanel) ...[
                const SizedBox(width: 20),
                const SizedBox(width: 300, child: DashboardRightPanel()),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MainColumn extends StatelessWidget {
  const _MainColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Welcome back! Here's what's happening at your academy today.",
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
        SizedBox(height: 20),
        _StatsRow(),
        SizedBox(height: 20),
        _ChartsRow(),
        SizedBox(height: 20),
        _ListsRow(),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        if (!wide) {
          return Column(
            children: [
              for (final item in DashboardData.stats) ...[
                StatCard(item: item),
                const SizedBox(height: 12),
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < DashboardData.stats.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(child: StatCard(item: DashboardData.stats[i])),
            ],
          ],
        );
      },
    );
  }
}

class _ChartsRow extends StatelessWidget {
  const _ChartsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return const Column(
            children: [
              EnrollmentChart(),
              SizedBox(height: 16),
              CoursesDonut(),
            ],
          );
        }
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: EnrollmentChart()),
            SizedBox(width: 16),
            Expanded(flex: 2, child: CoursesDonut()),
          ],
        );
      },
    );
  }
}

class _ListsRow extends StatelessWidget {
  const _ListsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return const Column(
            children: [
              RecentRegistrations(),
              SizedBox(height: 16),
              PopularCourses(),
            ],
          );
        }
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: RecentRegistrations()),
            SizedBox(width: 16),
            Expanded(flex: 2, child: PopularCourses()),
          ],
        );
      },
    );
  }
}

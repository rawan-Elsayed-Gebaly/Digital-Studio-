import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';

class StatItem {
  const StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.changeLabel,
    required this.isUp,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final String changeLabel;
  final bool isUp;
}

class RegistrationItem {
  const RegistrationItem({
    required this.name,
    required this.email,
    required this.course,
    required this.date,
    required this.status,
  });

  final String name;
  final String email;
  final String course;
  final String date;
  final String status;
}

class CourseItem {
  const CourseItem({
    required this.title,
    required this.students,
    required this.icon,
    required this.color,
  });

  final String title;
  final String students;
  final IconData icon;
  final Color color;
}

class SessionItem {
  const SessionItem({
    required this.title,
    required this.time,
    required this.seats,
    required this.color,
  });

  final String title;
  final String time;
  final String seats;
  final Color color;
}

class CategoryItem {
  const CategoryItem({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;
}

abstract final class DashboardData {
  static const stats = [
    StatItem(
      label: 'Active Courses',
      value: '8',
      icon: Icons.school_outlined,
      color: AppColors.courses,
      change: '2',
      changeLabel: 'from last month',
      isUp: true,
    ),
    StatItem(
      label: 'Total Students',
      value: '156',
      icon: Icons.groups_outlined,
      color: AppColors.students,
      change: '12',
      changeLabel: 'from last month',
      isUp: true,
    ),
    StatItem(
      label: 'Pending Registrations',
      value: '12',
      icon: Icons.person_outline,
      color: AppColors.pending,
      change: '5',
      changeLabel: 'from last week',
      isUp: false,
    ),
    StatItem(
      label: "Today's Sessions",
      value: '5',
      icon: Icons.calendar_today_outlined,
      color: AppColors.sessions,
      change: '1',
      changeLabel: 'from yesterday',
      isUp: true,
    ),
  ];

  static const enrollmentValues = [8.0, 16.0, 14.0, 23.0, 33.0];
  static const enrollmentLabels = [
    'Sep 23',
    'Sep 30',
    'Oct 7',
    'Oct 14',
    'Oct 21',
  ];

  static const categories = [
    CategoryItem(label: 'Programming', count: 3, color: Color(0xFF3B82F6)),
    CategoryItem(label: 'Design', count: 2, color: Color(0xFF2DD4BF)),
    CategoryItem(label: 'Business', count: 1, color: Color(0xFF4ADE80)),
    CategoryItem(label: 'Languages', count: 1, color: Color(0xFFFBBF24)),
    CategoryItem(label: 'Other', count: 1, color: Color(0xFFA78BFA)),
  ];

  static const registrations = [
    RegistrationItem(
      name: 'Ahmed Mohamed',
      email: 'ahmed@example.com',
      course: 'Flutter Development',
      date: '21 Oct 2025',
      status: 'Pending',
    ),
    RegistrationItem(
      name: 'Sara Ali',
      email: 'sara@example.com',
      course: 'Python Fundamentals',
      date: '21 Oct 2025',
      status: 'Confirmed',
    ),
    RegistrationItem(
      name: 'Omar Hassan',
      email: 'omar@example.com',
      course: 'UI/UX Design',
      date: '20 Oct 2025',
      status: 'Confirmed',
    ),
    RegistrationItem(
      name: 'Layla Ahmed',
      email: 'layla@example.com',
      course: 'Web Development',
      date: '20 Oct 2025',
      status: 'Pending',
    ),
    RegistrationItem(
      name: 'Youssef Khaled',
      email: 'youssef@example.com',
      course: 'Data Science Intro',
      date: '19 Oct 2025',
      status: 'Confirmed',
    ),
  ];

  static const popularCourses = [
    CourseItem(
      title: 'Python Fundamentals',
      students: '38 students',
      icon: Icons.code,
      color: Color(0xFF3B82F6),
    ),
    CourseItem(
      title: 'Web Development',
      students: '32 students',
      icon: Icons.terminal,
      color: Color(0xFFF59E0B),
    ),
    CourseItem(
      title: 'UI/UX Design',
      students: '24 students',
      icon: Icons.dashboard_customize_outlined,
      color: Color(0xFFEF4444),
    ),
    CourseItem(
      title: 'Flutter Development',
      students: '18 students',
      icon: Icons.flash_on_outlined,
      color: Color(0xFF22C55E),
    ),
    CourseItem(
      title: 'Data Science Intro',
      students: '12 students',
      icon: Icons.bar_chart_rounded,
      color: Color(0xFF6366F1),
    ),
  ];

  static const sessions = [
    SessionItem(
      title: 'Flutter Development',
      time: 'Tue, 21 Oct 2025 • 6:00 PM – 8:00 PM',
      seats: '12 / 20 seats',
      color: AppColors.primary,
    ),
    SessionItem(
      title: 'UI/UX Design',
      time: 'Wed, 22 Oct 2025 • 5:00 PM – 7:00 PM',
      seats: '8 / 15 seats',
      color: AppColors.sessions,
    ),
    SessionItem(
      title: 'Python Fundamentals',
      time: 'Thu, 23 Oct 2025 • 6:00 PM – 8:00 PM',
      seats: '10 / 18 seats',
      color: AppColors.students,
    ),
    SessionItem(
      title: 'Web Development',
      time: 'Sat, 25 Oct 2025 • 10:00 AM – 12:00 PM',
      seats: '14 / 20 seats',
      color: AppColors.pending,
    ),
    SessionItem(
      title: 'Data Science Intro',
      time: 'Sun, 26 Oct 2025 • 4:00 PM – 6:00 PM',
      seats: '11 / 16 seats',
      color: Color(0xFF22C55E),
    ),
  ];
}

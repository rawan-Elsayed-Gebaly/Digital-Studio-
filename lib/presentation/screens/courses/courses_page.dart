import 'package:flutter/material.dart';

import '../../../constrants/colors.dart';
import '../../../model/Course.dart';
import '../../../service/course_service.dart';
import '../../widgets/courses/courses_table.dart';
import '../../widgets/dashboard/dashboard_card.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../dashboard/dashboard_page.dart';
import 'add_course_page.dart';
import 'edit_course_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key, this.loader});

  final Future<List<Course>> Function()? loader;

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  static const _pageSize = 6;

  late Future<List<Course>> _coursesFuture;
  final _searchController = TextEditingController();
  String _statusFilter = 'All Statuses';
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _coursesFuture = (widget.loader ?? CourseService().loadAllCourses)();
    _searchController.addListener(() {
      setState(() => _page = 0);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _coursesFuture = (widget.loader ?? CourseService().loadAllCourses)();
    });
  }

  Future<void> _openAddCourse() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddCoursePage()),
    );
    if (saved == true && mounted) _reload();
  }

  Future<void> _openEditCourse(Course course) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EditCoursePage(course: course)),
    );
    if (saved == true && mounted) _reload();
  }

  Future<void> _deleteCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete course?'),
        content: Text('Are you sure you want to delete "${course.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await CourseService().deleteCourse(course.id!);
      if (mounted) _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete the course.')),
      );
    }
  }

  void _onNavTap(int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  List<Course> _filtered(List<Course> courses) {
    final query = _searchController.text.trim().toLowerCase();
    return courses.where((course) {
      final matchesStatus =
          _statusFilter == 'All Statuses' ||
          course.status.toLowerCase() == _statusFilter.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          course.name.toLowerCase().contains(query) ||
          course.instructor.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Row(
        children: [
          DashboardSidebar(selectedIndex: 1, onItemTap: _onNavTap),
          Expanded(
            child: Column(
              children: [
                const DashboardTopBar(),
                Expanded(
                  child: FutureBuilder<List<Course>>(
                    future: _coursesFuture,
                    builder: (context, snapshot) {
                      final courses = snapshot.data ?? const <Course>[];
                      final filtered = _filtered(courses);
                      final pageCount = (filtered.length / _pageSize).ceil();
                      final safePage = pageCount == 0
                          ? 0
                          : _page.clamp(0, pageCount - 1);
                      final start = safePage * _pageSize;
                      final pageItems = filtered.isEmpty
                          ? const <Course>[]
                          : filtered.sublist(
                              start,
                              (start + _pageSize).clamp(0, filtered.length),
                            );

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                        children: [
                          _Header(onAddCourse: _openAddCourse),
                          const SizedBox(height: 20),
                          DashboardCard(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                            child: Column(
                              children: [
                                _FiltersBar(
                                  searchController: _searchController,
                                  statusFilter: _statusFilter,
                                  statuses: _statusOptions(courses),
                                  onStatusChanged: (value) {
                                    setState(() {
                                      _statusFilter = value;
                                      _page = 0;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 48),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  )
                                else
                                  CoursesTable(
                                    courses: pageItems,
                                    onEdit: _openEditCourse,
                                    onDelete: _deleteCourse,
                                  ),
                                const SizedBox(height: 8),
                                _PaginationBar(
                                  shown: pageItems.length,
                                  total: filtered.length,
                                  page: safePage,
                                  pageCount: pageCount,
                                  onPrevious: safePage > 0
                                      ? () => setState(() => _page = safePage - 1)
                                      : null,
                                  onNext: safePage < pageCount - 1
                                      ? () => setState(() => _page = safePage + 1)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _statusOptions(List<Course> courses) {
    final values = <String>{
      'All Statuses',
      ...courses.map((course) => course.status),
    };
    if (!values.contains(_statusFilter)) values.add(_statusFilter);
    return values.toList();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onAddCourse});

  final VoidCallback onAddCourse;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_outlined, color: AppColors.text),
                  SizedBox(width: 10),
                  Text(
                    'Courses',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Manage your academy's courses. Add new courses, edit details, or remove them.",
                style: TextStyle(color: AppColors.muted, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 42,
          child: FilledButton.icon(
            onPressed: onAddCourse,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Course'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.searchController,
    required this.statusFilter,
    required this.statuses,
    required this.onStatusChanged,
  });

  final TextEditingController searchController;
  final String statusFilter;
  final List<String> statuses;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 720;
        final search = TextField(
          controller: searchController,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: 'Search by course name or instructor...',
            hintStyle: const TextStyle(color: AppColors.hint, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: AppColors.muted),
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
          ),
        );

        final filter = SizedBox(
          width: stacked ? double.infinity : 200,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: statuses.contains(statusFilter)
                ? statusFilter
                : statuses.first,
            items: [
              for (final status in statuses)
                DropdownMenuItem(value: status, child: Text(status)),
            ],
            onChanged: (value) {
              if (value != null) onStatusChanged(value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFD),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
            ),
            style: const TextStyle(color: AppColors.text, fontSize: 13),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          ),
        );

        if (stacked) {
          return Column(
            children: [
              search,
              const SizedBox(height: 12),
              filter,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: 12),
            filter,
          ],
        );
      },
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.shown,
    required this.total,
    required this.page,
    required this.pageCount,
    required this.onPrevious,
    required this.onNext,
  });

  final int shown;
  final int total;
  final int page;
  final int pageCount;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        children: [
          Text(
            'Showing $shown of $total courses',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const Spacer(),
          _PageButton(icon: Icons.chevron_left, onPressed: onPrevious),
          const SizedBox(width: 6),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${pageCount == 0 ? 1 : page + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          _PageButton(icon: Icons.chevron_right, onPressed: onNext),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: AppColors.muted),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../constrants/colors.dart';
import '../../../model/Course.dart';
import '../../../service/add_course_service.dart';
import '../../../utiles/course_data_validator.dart';
import '../../widgets/courses/course_form_field.dart';
import '../../widgets/courses/course_poster_picker.dart';
import '../../widgets/courses/course_preview_card.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../dashboard/dashboard_page.dart';
import 'add_course_page.dart';
import 'courses_page.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage({required this.course, super.key});

  final Course course;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  static const _statuses = ['Active', 'Completed', 'Pending'];
  static const _maxPickBytes = 5 * 1024 * 1024;
  static const _allowedExts = {'jpg', 'jpeg', 'png', 'webp'};

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructorController = TextEditingController();
  final _capacityController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddCourseService? _courseServiceInstance;
  AddCourseService get _courseService =>
      _courseServiceInstance ??= AddCourseService();

  late String _status;
  Uint8List? _posterBytes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final course = widget.course;
    _nameController.text = course.name;
    _priceController.text = _priceText(course.price);
    _durationController.text = course.duration;
    _instructorController.text = course.instructor;
    _capacityController.text = '${course.capacity}';
    _descriptionController.text = course.description;
    _status = _statuses.contains(course.status) ? course.status : 'Active';

    for (final controller in [
      _nameController,
      _priceController,
      _durationController,
      _instructorController,
      _capacityController,
      _descriptionController,
    ]) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _instructorController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String get _existingPosterUrl {
    final value = widget.course.posterUrl.trim();
    if (value.isEmpty) return '';
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return _courseService.publicUrlFor(value);
  }

  String _priceText(double price) {
    return price == price.roundToDouble()
        ? price.toInt().toString()
        : price.toString();
  }

  String _previewPrice() {
    final parsed = double.tryParse(_priceController.text.trim());
    if (parsed == null) return 'EGP 0';
    final digits = parsed == parsed.roundToDouble()
        ? parsed.toInt().toString()
        : parsed.toStringAsFixed(2);
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return 'EGP $buffer';
  }

  Future<void> _choosePoster() async {
    if (_isSaving) return;

    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 960,
      maxHeight: 960,
    );
    if (file == null || !mounted) return;

    final ext = file.name.contains('.')
        ? file.name.split('.').last.toLowerCase()
        : 'jpg';
    if (!_allowedExts.contains(ext)) {
      _showMessage('Please choose a JPG, PNG or WebP image.');
      return;
    }
    if (await file.length() > _maxPickBytes) {
      _showMessage('Image must be under 5 MB.');
      return;
    }

    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _posterBytes = bytes);
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveCourse() async {
    if (_isSaving) return;

    final id = widget.course.id;
    if (id == null) {
      _showMessage('This course cannot be updated.');
      return;
    }

    final result = CourseValidator.validate(
      name: _nameController.text,
      price: _priceController.text,
      description: _descriptionController.text,
      duration: _durationController.text,
      status: _status,
      capacity: _capacityController.text,
      instructor: _instructorController.text,
    );
    if (!result.isValid) return _showMessage(result.error!);
    final input = result.data!;

    setState(() => _isSaving = true);

    String imagePath = widget.course.posterUrl;
    String? uploadedPath;
    try {
      if (_posterBytes != null) {
        final compressed = await compressPoster(_posterBytes!);
        final path = 'images/${const Uuid().v4()}.jpg';
        await _courseService.uploadImageFile(
          path: path,
          fileBytes: compressed,
          contentType: 'image/jpeg',
        );
        uploadedPath = path;
        imagePath = path;
      }

      await _courseService.updateCourse(
        id: id,
        courseName: input.name,
        price: input.price,
        imagePath: imagePath,
        description: input.description,
        duration: input.duration,
        status: input.status,
        capacity: input.capacity,
        instructor: input.instructor,
      );

      final oldPath = _courseService.storagePathFrom(widget.course.posterUrl);
      if (uploadedPath != null && oldPath.isNotEmpty && oldPath != uploadedPath) {
        unawaited(_courseService.deleteImage(oldPath));
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e, st) {
      debugPrint('Update failed: $e\n$st');
      if (uploadedPath != null) {
        unawaited(_courseService.deleteImage(uploadedPath));
      }
      _showMessage('Could not update the course. Please try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onNavTap(int index) {
    if (index == 1) {
      _backToCourses();
      return;
    }
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  void _backToCourses() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const CoursesPage()));
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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(28, 8, 28, 12),
                          children: [
                            _BackLink(onTap: _backToCourses),
                            const SizedBox(height: 16),
                            const _PageTitle(),
                            const SizedBox(height: 20),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final stacked = constraints.maxWidth < 980;
                                final form = _CourseInformationCard(
                                  nameController: _nameController,
                                  priceController: _priceController,
                                  durationController: _durationController,
                                  instructorController: _instructorController,
                                  capacityController: _capacityController,
                                  detailsController: _descriptionController,
                                  status: _status,
                                  onStatusChanged: (value) {
                                    setState(() => _status = value);
                                  },
                                );
                                final side = Column(
                                  children: [
                                    CoursePosterPicker(
                                      imageBytes: _posterBytes,
                                      existingImageUrl: _existingPosterUrl,
                                      onChooseImage: _choosePoster,
                                      showImagePreview: false,
                                    ),
                                    const SizedBox(height: 16),
                                    CoursePreviewCard(
                                      name: _nameController.text.trim(),
                                      instructor: _instructorController.text
                                          .trim(),
                                      duration: _durationController.text.trim(),
                                      price: _previewPrice(),
                                      capacity: _capacityController.text
                                          .trim(),
                                      status: _status,
                                      imageBytes: _posterBytes,
                                      imageUrl: _existingPosterUrl,
                                    ),
                                  ],
                                );
                                if (stacked) {
                                  return Column(
                                    children: [
                                      form,
                                      const SizedBox(height: 16),
                                      side,
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 3, child: form),
                                    const SizedBox(width: 16),
                                    Expanded(flex: 2, child: side),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
                        child: _FooterActions(
                          isSaving: _isSaving,
                          onCancel: _backToCourses,
                          onSave: _saveCourse,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, size: 16, color: AppColors.muted),
            SizedBox(width: 6),
            Text(
              'Back to Courses',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.edit_outlined, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              'Edit Course',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Update the course details and save changes.',
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
      ],
    );
  }
}

class _CourseInformationCard extends StatelessWidget {
  const _CourseInformationCard({
    required this.nameController,
    required this.priceController,
    required this.durationController,
    required this.instructorController,
    required this.capacityController,
    required this.detailsController,
    required this.status,
    required this.onStatusChanged,
  });

  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController durationController;
  final TextEditingController instructorController;
  final TextEditingController capacityController;
  final TextEditingController detailsController;
  final String status;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      icon: Icons.menu_book_outlined,
      title: 'Course Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseFormField(
            label: 'Course Name *',
            hint: 'e.g. Flutter Development',
            controller: nameController,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 560;
              final price = CourseFormField(
                label: 'Price (EGP) *',
                hint: 'e.g. 3000',
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              );
              final duration = CourseFormField(
                label: 'Duration *',
                hint: 'e.g. 12 weeks',
                controller: durationController,
              );
              if (stacked) {
                return Column(
                  children: [price, const SizedBox(height: 16), duration],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: price),
                  const SizedBox(width: 16),
                  Expanded(child: duration),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          CourseFormField(
            label: 'Instructor *',
            hint: 'e.g. Ahmed Mohamed',
            controller: instructorController,
          ),
          const SizedBox(height: 16),
          const Text(
            'Status *',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: status,
            items: [
              for (final value in _EditCoursePageState._statuses)
                DropdownMenuItem(value: value, child: Text(value)),
            ],
            onChanged: (value) {
              if (value != null) onStatusChanged(value);
            },
            decoration: courseInputDecoration(),
            style: const TextStyle(color: AppColors.text, fontSize: 14),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          CourseFormField(
            label: 'Total Seats / Capacity *',
            hint: 'e.g. 20',
            controller: capacityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefix: const Icon(
              Icons.person_outline,
              color: AppColors.muted,
              size: 20,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Details *',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const _DetailsToolbar(),
                const Divider(height: 1, color: AppColors.border),
                TextField(
                  controller: detailsController,
                  maxLines: 7,
                  maxLength: 2000,
                  cursorColor: AppColors.primary,
                  style: const TextStyle(color: AppColors.text, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText:
                        'Enter course details, what students will learn, and any additional information...',
                    hintStyle: TextStyle(color: AppColors.hint, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(14, 12, 14, 8),
                    counterText: '',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Text(
                      '${detailsController.text.length}/2000',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsToolbar extends StatelessWidget {
  const _DetailsToolbar();

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.format_bold,
      Icons.format_italic,
      Icons.format_underline,
      Icons.format_list_numbered,
      Icons.format_list_bulleted,
      Icons.link,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          for (final icon in icons)
            IconButton(
              onPressed: () {},
              icon: Icon(icon, size: 18, color: AppColors.muted),
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.onCancel,
    required this.onSave,
    required this.isSaving,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 42,
          child: OutlinedButton(
            onPressed: isSaving ? null : onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 42,
          child: FilledButton.icon(
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(isSaving ? 'Saving...' : 'Save Changes'),
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

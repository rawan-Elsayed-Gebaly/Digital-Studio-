import 'package:business_managment_system/service/add_course_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constrants/colors.dart';
import '../../../utiles/compress.dart';
import '../../../utiles/course_data_validator.dart';
import '../../widgets/courses/course_form_field.dart';
import '../../widgets/courses/course_poster_picker.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../dashboard/dashboard_page.dart';
import 'courses_page.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


const _maxWidth = 960;
const _targetBytes = 150 * 1024;

Uint8List _compressSync(Uint8List original) {
  final decoded = img.decodeImage(original);
  if (decoded == null) throw Exception('Unsupported image');

  final oriented = img.bakeOrientation(decoded); // fix phone rotation
  final resized = oriented.width > _maxWidth
      ? img.copyResize(oriented, width: _maxWidth)
      : oriented;

  var quality = 75;
  var out = img.encodeJpg(resized, quality: quality);
  while (out.length > _targetBytes && quality > 40) {
    quality -= 10;
    out = img.encodeJpg(resized, quality: quality);
  }
  return Uint8List.fromList(out);
}

Future<Uint8List> compressPoster(Uint8List bytes) =>
    compute(_compressSync, bytes);


class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  static const _statuses = ['Active', 'Completed', 'Pending'];

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructorController = TextEditingController();
  final _capacityController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'Active';

  final _addCourseService = AddCourseService();
  bool _isSaving = false;

  static const _maxPickBytes = 5 * 1024 * 1024;
  static const _allowedExts = {'jpg', 'jpeg', 'png', 'webp'};

  Uint8List? _posterBytes; // preview only (not uploaded yet)

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

    // 1. Validate first: nothing is uploaded if the form is bad
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

    String? uploadedPath;
    try {
      // 2. Upload the poster (optional)
      if (_posterBytes != null) {
        // Always output JPEG, so the extension and content type are fixed.
        final compressed = await compressPoster(_posterBytes!);
        final path = 'images/${const Uuid().v4()}.jpg';

        await _addCourseService.uploadImageFile(
          path: path,
          fileBytes: compressed,
          contentType: 'image/jpeg',
        );
        uploadedPath = path; // set only after the upload succeeded
      }

      // 3. Insert the course row using the validated, typed values
      await _addCourseService.createCourse(
        courseName: input.name,
        price: input.price,
        imagePath: uploadedPath,
        description: input.description,
        duration: input.duration,
        status: input.status,
        capacity: input.capacity,
        instructor: input.instructor,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e, st) {
      debugPrint('Save failed: $e\n$st');
      if (uploadedPath != null) {
        // the row was not created, so remove the file (no orphans)
        unawaited(_addCourseService.deleteImage(uploadedPath));
      }
      _showMessage('Could not save the course. Please try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() => setState(() {}));
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
                                final poster = CoursePosterPicker(
                                  imageBytes: _posterBytes,
                                  onChooseImage: _choosePoster,
                                );
                                if (stacked) {
                                  return Column(
                                    children: [
                                      form,
                                      const SizedBox(height: 16),
                                      poster,
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 3, child: form),
                                    const SizedBox(width: 16),
                                    Expanded(flex: 2, child: poster),
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
                          onCancel: _backToCourses,
                          onCreate: () {
                            _saveCourse();
                          },
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
            Icon(Icons.add_circle_outline, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              'Add New Course',
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
          'Fill in the details below to add a new course to your academy.',
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
              for (final value in _AddCoursePageState._statuses)
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
  const _FooterActions({required this.onCancel, required this.onCreate});

  final VoidCallback onCancel;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 42,
          child: OutlinedButton(
            onPressed: onCancel,
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
            onPressed: onCreate,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Course'),
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

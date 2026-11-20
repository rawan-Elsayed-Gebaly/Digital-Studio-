class CourseInput {
  final String name;
  final double price;
  final String description;
  final String duration;
  final String status;
  final int capacity;
  final String instructor;

  const CourseInput({
    required this.name,
    required this.price,
    required this.description,
    required this.duration,
    required this.status,
    required this.capacity,
    required this.instructor,
  });
}

class CourseValidationResult {
  final CourseInput? data;
  final String? error;

  const CourseValidationResult.ok(CourseInput this.data) : error = null;
  const CourseValidationResult.fail(String this.error) : data = null;

  bool get isValid => data != null;
}

class CourseValidator {
  static const allowedStatuses = {'Active', 'Completed', 'Pending'}; // match your app's values

  static CourseValidationResult validate({
    required String name,
    required String price,
    required String description,
    required String duration,
    required String status,
    required String capacity,
    required String instructor,
  }) {
    final n = name.trim();
    final d = description.trim();
    final dur = duration.trim();
    final ins = instructor.trim();
    final p = double.tryParse(price.trim());
    final c = int.tryParse(capacity.trim());

    if (n.isEmpty) return const CourseValidationResult.fail('Course name is required.');
    if (n.length > 100) return const CourseValidationResult.fail('Course name is too long (max 100).');
    if (p == null || p < 0) return const CourseValidationResult.fail('Enter a valid price.');
    if (p > 1000000) return const CourseValidationResult.fail('Price is too high.');
    if (c == null || c <= 0) return const CourseValidationResult.fail('Capacity must be a positive number.');
    if (c > 10000) return const CourseValidationResult.fail('Capacity is too high.');
    if (ins.isEmpty) return const CourseValidationResult.fail('Instructor is required.');
    if (dur.isEmpty) return const CourseValidationResult.fail('Duration is required.');
    if (!allowedStatuses.contains(status)) return const CourseValidationResult.fail('Choose a valid status.');
    if (d.length > 1000) return const CourseValidationResult.fail('Description is too long (max 1000).');

    return CourseValidationResult.ok(CourseInput(
      name: n,
      price: p,
      description: d,
      duration: dur,
      status: status,
      capacity: c,
      instructor: ins,
    ));
  }
}
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/Course.dart';

class AddCourseService {
  final SupabaseClient _cloud = Supabase.instance.client;

  Future<String> uploadImageFile({
    required String path,
    required Uint8List fileBytes,
    required String contentType,
  }) async {
    await _cloud.storage.from('images').uploadBinary(
      path,
      fileBytes,
      fileOptions: FileOptions(
        contentType: contentType,
        cacheControl: '31536000', // safe: every upload has a unique name
        upsert: false,
      ),
    );
    return path;
  }

  Future<void> deleteImage(String path) {
    final storagePath = storagePathFrom(path);
    if (storagePath.isEmpty) return Future.value();
    return _cloud.storage.from('images').remove([storagePath]);
  }

  String publicUrlFor(String path) {
    final value = path.trim();
    if (value.isEmpty) return '';
    if (value.startsWith('http://') || value.startsWith('https://')) return value;
    return _cloud.storage.from('images').getPublicUrl(value);
  }

  String storagePathFrom(String pathOrUrl) {
    final value = pathOrUrl.trim();
    if (value.isEmpty) return '';
    if (!value.startsWith('http')) return value;
    const marker = '/object/public/images/';
    final index = value.indexOf(marker);
    if (index < 0) return '';
    return value.substring(index + marker.length);
  }

  Future<void> createCourse({
    required String courseName,
    required double price,
    String? imagePath,
    required String description,
    required String duration,
    required String status,
    required int capacity,
    required String instructor,
  }) async {
    final course = Course(
      name: courseName,
      price: price,
      posterUrl: imagePath!,
      description: description,
      duration: duration,
      status: status,
      capacity: capacity,
      instructor: instructor,
    );

    // No try/catch: the screen catches the error and rolls back the image.
    await _cloud.from('course').insert(course);
  }

  Future<void> updateCourse({
    required int id,
    required String courseName,
    required double price,
    required String imagePath,
    required String description,
    required String duration,
    required String status,
    required int capacity,
    required String instructor,
  }) async {
    await _cloud.from('course').update({
      'name': courseName,
      'price': price,
      'poster_url': imagePath,
      'description': description,
      'duration': duration,
      'status': status,
      'capacity': capacity,
      'instructor': instructor,
    }).eq('id', id);
  }
}


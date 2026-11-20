import 'dart:convert';

import 'package:business_managment_system/model/Course.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseService {
  final cloud = Supabase.instance.client;
  Future<List<Course>> loadAllCourses() async {
    try {
      final result = await cloud.from('course').select();
      final courses = courseFromJson(jsonEncode(result));
      return courses ;
      
    } catch (e) {
      print('error in loading courses ') ;
      print(e);
      return [];
    }
  }

  Future<void> loadCourses() async {
    try {
      final courses = await cloud.rpc('get_course_without_description');
      print(courses);
    } catch (e) {
      print('error in loading courses ') ;
      print(e);
    }
  }

  Future<void> deleteCourse(int id) async {
    await cloud.from('course').delete().eq('id', id);
  }
}

// To parse this JSON data, do
//
//     final course = courseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Course> courseFromJson(String str) => List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

String courseToJson(List<Course> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Course {
  final int? id;
  final DateTime? createdAt;
  final String name;
  final double price;
  final String posterUrl;
  final String description;
  final String duration;
  final String status;
  final int capacity;
  final String instructor;

  Course({
     this.id,
     this.createdAt,
    required this.name,
    required this.price,
    required this.posterUrl,
    required this.description,
    required this.duration,
    required this.status,
    required this.capacity,
    required this.instructor,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    name: json["name"],
    price: (json["price"] as num).toDouble(),
    posterUrl: json["poster_url"] ?? "",
    description: json["description"] ?? "",
    duration: json["duration"] ?? "",
    status: json["status"] ?? "Active",
    capacity: json["capacity"] ?? 0,
    instructor: json["instructor"] ?? "",
  );

  Map<String, dynamic> toJson() => {

    "name": name,
    "price": price,
    "poster_url": posterUrl,
    "description": description,
    "duration": duration,
    "status": status,
    "capacity": capacity,
    "instructor": instructor,
  };
}

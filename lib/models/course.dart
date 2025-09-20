import 'package:flutter/cupertino.dart';

class Course {
  final int id;
  final String title;
  final String description;
  final String category;
  final Color color;
  final IconData icon;
  final int lessons;
  final double progress;
  final String difficulty;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.color,
    required this.icon,
    required this.lessons,
    this.progress = 0.0,
    this.difficulty = 'Beginner',
  });
}
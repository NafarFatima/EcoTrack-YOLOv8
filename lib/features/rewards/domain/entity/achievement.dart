import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final Color color;
  final Color bgColor;
  final bool isLocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.bgColor,
    this.isLocked = false,
  });
}

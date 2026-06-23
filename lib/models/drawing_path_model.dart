import 'package:flutter/material.dart';

class DrawingPathModel {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingPathModel({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

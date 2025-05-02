import 'package:flutter/material.dart';

class DrawingAction {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  bool isSelected;

  DrawingAction({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isSelected = false,
  });
}
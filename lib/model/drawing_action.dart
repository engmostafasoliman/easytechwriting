import 'package:flutter/material.dart';

class DrawingAction {
  List<Offset> points;
  Color color;
  double strokeWidth;
  bool isSelected;

  DrawingAction({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isSelected = false,
  });
}
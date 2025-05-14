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
  DrawingAction copyWith({
    List<Offset>? points,
    Color? color,
    double? strokeWidth,
    bool? isSelected,
  }) {
    return DrawingAction(
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isSelected: isSelected ?? this.isSelected,
    );
  }

}
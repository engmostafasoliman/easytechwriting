import 'dart:ui';

class DrawingAction {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isSelected;
  final bool isErasing; // <-- Add this

  DrawingAction({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isSelected = false,
    this.isErasing = false, // <-- Default to false
  });

  DrawingAction copyWith({
    List<Offset>? points,
    Color? color,
    double? strokeWidth,
    bool? isSelected,
    bool? isErasing,
  }) {
    return DrawingAction(
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isSelected: isSelected ?? this.isSelected,
      isErasing: isErasing ?? this.isErasing,
    );
  }
}

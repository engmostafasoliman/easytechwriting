import 'package:easytech/model/drawing_action.dart';
import 'package:flutter/material.dart';

import 'dart:ui';


class MyPainter extends CustomPainter {
  final List<DrawingAction> drawingHistory;
  final void Function(DrawingAction?) onSelectDrawingAction;

  MyPainter({
    required this.drawingHistory,
    required this.onSelectDrawingAction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var action in drawingHistory) {
      final paint = Paint()
        ..color = action.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = action.strokeWidth;

      if (action.isSelected) {
        final selectionPaint = Paint()
          ..color = Colors.blue.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        if (action.points.isNotEmpty) {
          double minX = action.points[0].dx;
          double minY = action.points[0].dy;
          double maxX = action.points[0].dx;
          double maxY = action.points[0].dy;

          for (var point in action.points) {
            minX = point.dx < minX ? point.dx : minX;
            minY = point.dy < minY ? point.dy : minY;
            maxX = point.dx > maxX ? point.dx : maxX;
            maxY = point.dy > maxY ? point.dy : maxY;
          }

          canvas.drawRect(
            Rect.fromLTRB(minX - 1, minY - 1, maxX + 1, maxY + 1),
            selectionPaint,
          );
        }
      }

      for (int i = 0; i < action.points.length - 1; i++) {
        if (action.points[i] != Offset.zero &&
            action.points[i + 1] != Offset.zero) {
          canvas.drawLine(action.points[i], action.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    DrawingAction? selectedAction;
    for (var action in drawingHistory.reversed) {
      for (int i = 0; i < action.points.length - 1; i++) {
        if (action.points[i] != Offset.zero &&
            action.points[i + 1] != Offset.zero &&
            _isPointOnLine(position, action.points[i], action.points[i + 1], action.strokeWidth)) {
          selectedAction = action;
          break;
        }
      }
      if (selectedAction != null) break;
    }

    onSelectDrawingAction(selectedAction);
    return true;
  }

  bool _isPointOnLine(Offset point, Offset start, Offset end, double width) {
    double dist = _calculateDistanceToLine(point, start, end);
    return dist <= width + 1;
  }

  double _calculateDistanceToLine(Offset point, Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    if (dx == 0 && dy == 0) return (point - start).distance;

    final t = ((point.dx - start.dx) * dx + (point.dy - start.dy) * dy) / (dx * dx + dy * dy);
    if (t < 0) return (point - start).distance;
    if (t > 1) return (point - end).distance;

    final projection = Offset(start.dx + t * dx, start.dy + t * dy);
    return (point - projection).distance;
  }
}

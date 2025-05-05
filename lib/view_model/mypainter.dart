import 'package:easytech/model/drawing_action.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

class MyPainter extends CustomPainter {
  final List<DrawingAction> drawingHistory;
  final Function(DrawingAction?) onSelectDrawingAction;

  MyPainter(this.drawingHistory, this.onSelectDrawingAction);

  @override
  void paint(Canvas canvas, Size size) {
    for (var action in drawingHistory) {
      final paint = Paint()
        ..color = action.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = action.strokeWidth;

      if (action.isSelected) {
        // If the shape is selected, draw a selection rectangle around it
        final selectionPaint = Paint()
          ..color = Colors.blue.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        // Calculate the bounding box of the shape
        if (action.points.isNotEmpty) {
          double minX = action.points[0].dx;
          double minY = action.points[0].dy;
          double maxX = action.points[0].dx;
          double maxY = action.points[0].dy;

          for (var point in action.points) {
            minX = minX < point.dx ? minX : point.dx;
            minY = minY < point.dy ? minY : point.dy;
            maxX = maxX > point.dx ? maxX : point.dx;
            maxY = maxY > point.dy ? maxY : point.dy;
          }

          canvas.drawRect(
            Rect.fromLTRB(minX - 1, minY - 1, maxX + 1, maxY + 1),
            selectionPaint,
          );
        }
      }
      //draw the line
      for (int i = 0; i < action.points.length - 1; i++) {
        if (action.points[i] != Offset.zero &&
            action.points[i + 1] != Offset.zero) {
          canvas.drawLine(action.points[i], action.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // Implement hit test to detect which shape is clicked
  @override
  bool hitTest(Offset position) {
    DrawingAction? selectedAction;
    for (var action in drawingHistory.reversed) {
      for (int i = 0; i < action.points.length - 1; i++) {
        if (action.points[i] != Offset.zero &&
            action.points[i + 1] != Offset.zero) {
          // Check if the tap is close to the line
          if (_isPointOnLine(position, action.points[i], action.points[i + 1],
              action.strokeWidth)) {
            selectedAction = action;
            break; // Select only the first shape clicked
          }
        }
      }
      if (selectedAction != null) {
        break;
      }
    }
    onSelectDrawingAction(selectedAction);
    return true;
  }

  // Helper method to check if a point is close to a line
  bool _isPointOnLine(
      Offset point, Offset lineStart, Offset lineEnd, double strokeWidth) {
    double distance = _calculateDistanceToLine(point, lineStart, lineEnd);
    return distance <= strokeWidth + 1; // Tolerance for tap detection
  }

  // Helper method to calculate the distance between a point and a line segment
  double _calculateDistanceToLine(
      Offset point, Offset lineStart, Offset lineEnd) {
    final double dx = lineEnd.dx - lineStart.dx;
    final double dy = lineEnd.dy - lineStart.dy;

    if (dx == 0 && dy == 0) {
      // The line segment is a point
      return (point - lineStart).distance;
    }

    final double t = ((point.dx - lineStart.dx) * dx +
        (point.dy - lineStart.dy) * dy) /
        (dx * dx + dy * dy);

    if (t < 0) {
      // The nearest point is lineStart
      return (point - lineStart).distance;
    } else if (t > 1) {
      // The nearest point is lineEnd
      return (point - lineEnd).distance;
    } else {
      // The nearest point is on the line segment
      final Offset nearest = Offset(lineStart.dx + t * dx, lineStart.dy + t * dy);
      return (point - nearest).distance;
    }
  }
}
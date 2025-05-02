// import 'package:easytech/model/drawing_action.dart';
// import 'package:flutter/material.dart';
//
//
// class MyPainter extends CustomPainter {
//   final List<DrawingAction> drawingActions;
//   final void Function(DrawingAction?) onSelectDrawingAction;
//
//   MyPainter(this.drawingActions, this.onSelectDrawingAction);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Create a Paint object for drawing lines
//     final paint = Paint()
//       ..isAntiAlias = true
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round;
//
//     // Draw each line in the history
//     for (final action in drawingActions) {
//       paint.color = action.color;
//       paint.strokeWidth = action.strokeWidth;
//
//       //if selected we add a bold line
//       if (action.isSelected) {
//         paint.strokeWidth = action.strokeWidth + 5;
//       }
//
//       // Draw the line using the points
//       for (int i = 0; i < action.points.length - 1; i++) {
//         canvas.drawLine(action.points[i], action.points[i + 1], paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(MyPainter oldDelegate) {
//     return oldDelegate.drawingActions != drawingActions;
//   }
//
//   // Handle tap events
//   @override
//   bool hitTest(Offset position) {
//     for (final action in drawingActions.reversed) {
//       for (int i = 0; i < action.points.length - 1; i++) {
//         if (_isPointOnLine(position, action.points[i],
//             action.points[i + 1], action.strokeWidth)) {
//           onSelectDrawingAction(action);
//           return true; // Stop searching after finding the first match
//         }
//       }
//       if (action.isSelected) {
//         onSelectDrawingAction(null);
//         return true; // Stop searching after finding the first match
//       }
//     }
//     return false;
//   }
//
//   // Helper method to check if a point is close to a line
//   bool _isPointOnLine(
//       Offset point, Offset lineStart, Offset lineEnd, double strokeWidth) {
//     double distance = _calculateDistanceToLine(point, lineStart, lineEnd);
//     return distance <= strokeWidth + 5; // Tolerance for tap detection
//   }
//
//   // Helper method to calculate the distance between a point and a line segment
//   double _calculateDistanceToLine(
//       Offset point, Offset lineStart, Offset lineEnd) {
//     final double dx = lineEnd.dx - lineStart.dx;
//     final double dy = lineEnd.dy - lineStart.dy;
//
//     if (dx == 0 && dy == 0) {
//       // The line segment is a point
//       return (point - lineStart).distance;
//     }
//
//     final double t = ((point.dx - lineStart.dx) * dx +
//         (point.dy - lineStart.dy) * dy) /
//         (dx * dx + dy * dy);
//
//     if (t < 0) {
//       // The nearest point is lineStart
//       return (point - lineStart).distance;
//     } else if (t > 1) {
//       // The nearest point is lineEnd
//       return (point - lineEnd).distance;
//     } else {
//       // The nearest point is on the line segment
//       final Offset nearest = Offset(lineStart.dx + t * dx, lineStart.dy + t * dy);
//       return (point - nearest).distance;
//     }
//   }
// }
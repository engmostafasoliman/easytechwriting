import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/drawing_action.dart';

class DrawingController extends StateNotifier<List<DrawingAction>> {
  DrawingController() : super([]);

  final List<DrawingAction> _redoStack = [];

  DrawingAction? _currentDrawingAction;

  void addAction(DrawingAction action) {
    state = [...state, action];
  }

  void addPoint(Offset point, Color color, double strokeWidth) {
    if (_currentDrawingAction == null) {
      _currentDrawingAction = DrawingAction(
        points: [],
        color: color,
        strokeWidth: strokeWidth,
      );
      state = [...state, _currentDrawingAction!];
    }

    _currentDrawingAction!.points.add(point);
    // To trigger repaint while drawing
    state = [...state];
  }

  void finishDrawing() {
    _currentDrawingAction = null;
    _redoStack.clear();
  }



  void undo() {
    if (state.isNotEmpty) {
      _redoStack.add(state.last);
      state = [...state..removeLast()];
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      state = [...state, _redoStack.removeLast()];
    }
  }

  void clear() {
    state = [];
    _redoStack.clear();
  }

  void deleteSelected() {
    state = state.where((action) => !action.isSelected).toList();
  }

  void selectAction(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        state[i].copyWith(isSelected: i == index)
    ];
  }
}

final drawingProvider =
StateNotifierProvider<DrawingController, List<DrawingAction>>((ref) {
  return DrawingController();
});

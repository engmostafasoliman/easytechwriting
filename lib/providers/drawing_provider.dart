import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/drawing_action.dart';

class DrawingController extends StateNotifier<List<DrawingAction>> {
  DrawingController() : super([]);

  final List<DrawingAction> _redoStack = [];
  DrawingAction? _currentDrawingAction;
  final eraserPositionProvider = StateProvider<Offset?>((ref) => null);

  void addPoint(
    Offset point,
    Color color,
    double strokeWidth, {
    bool isErasing = false,
  }) {
    if (_currentDrawingAction == null) {
      _currentDrawingAction = DrawingAction(
        points: [],
        color: color,
        strokeWidth: isErasing ? 50 : strokeWidth,
        isErasing: isErasing,
      );
      state = [...state, _currentDrawingAction!];
    }

    _currentDrawingAction!.points.add(point);
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
}

final drawingProvider =
    StateNotifierProvider<DrawingController, List<DrawingAction>>((ref) {
      return DrawingController();
    });
final selectedColorProvider = StateProvider<Color>((ref) => Colors.black);
final strokeWidthProvider = StateProvider<double>((ref) => 2.0);
final isErasingProvider = StateProvider<bool>((ref) => false);
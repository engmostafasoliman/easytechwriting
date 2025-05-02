// draw_screen.dart
import 'package:easytech/model/drawing_action.dart';
import 'package:easytech/view_model/mypainter.dart';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<String> imageList = [
    "assets/background_board/white_board.png",
    "assets/background_board/black_board.png",
    "assets/background_board/blue_cell.jpg",
    "assets/background_board/line_pattern.jpg",
    "assets/background_board/note_book.jpg",
    "assets/background_board/small_cell.png",
    "assets/background_board/striped_paper.jpg",

  ];
  int _counter = 0;

  Color _selectedColor = Colors.black;
  double _strokeWidth = 5.0;
  List<DrawingAction> _drawingHistory = [];
  List<DrawingAction> _redoStack = [];
  List<Offset> _currentPoints = <Offset>[]; // Store points for the current action

  // Add a DrawingAction for current line
  DrawingAction? _currentDrawingAction;
  DrawingAction? _selectedDrawingAction;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter == imageList.length) {
        _counter = 0;
      }
    });
  }

  void _changeColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _changeStrokeWidth(double width) {
    setState(() {
      _strokeWidth = width;
    });
  }

  // _addPoint to _currentPoints
  void _addPoint(Offset point) {
    setState(() {
      _currentPoints = List.from(_currentPoints)..add(point);

      // create and add a new DrawingAction for the current line
      if (_currentDrawingAction == null) {
        _currentDrawingAction = DrawingAction(
            points: [], color: _selectedColor, strokeWidth: _strokeWidth);
        _drawingHistory.add(_currentDrawingAction!);
      }
      _currentDrawingAction!.points.add(point);
    });
  }

  // Add the current drawing action to the history
  void _saveDrawingAction() {
    if (_currentPoints.isNotEmpty) {
      setState(() {
        _currentPoints.clear(); // Clear the points for the next action
        _redoStack.clear(); // Clear the redo stack on new drawing
        _currentDrawingAction = null; //clear the current DrawingAction
      });
    }
  }

  //Undo
  void _undo() {
    if (_drawingHistory.isNotEmpty) {
      setState(() {
        _redoStack.add(_drawingHistory.removeLast());
        _currentDrawingAction = null;
      });
    }
  }

  //Redo
  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _drawingHistory.add(_redoStack.removeLast());
        _currentDrawingAction = null;
      });
    }
  }

  // Clear all the screen
  void _clearPoints() {
    setState(() {
      _drawingHistory.clear();
      _redoStack.clear();
      _currentPoints.clear();
      _currentDrawingAction = null;
      _selectedDrawingAction = null;
    });
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: _changeColor,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Handle tap on CustomPaint
  void _onSelectDrawingAction(DrawingAction? action) {
    setState(() {
      // Unselect previously selected action
      if (_selectedDrawingAction != null) {
        _selectedDrawingAction!.isSelected = false;
      }

      // Select the new one
      _selectedDrawingAction = action;

      if (_selectedDrawingAction != null) {
        _selectedDrawingAction!.isSelected = true;
      }
    });
  }

  //delete selected DrawingAction
  void _deleteSelectedDrawingAction() {
    setState(() {
      if (_selectedDrawingAction != null) {
        _drawingHistory.remove(_selectedDrawingAction);
        _redoStack.clear();
        _selectedDrawingAction = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          // Handle tap down to select a shape
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(details.globalPosition);
        },
        onPanStart: (details) {
          // add a point when start touching the screen
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          _addPoint(localPosition);
        },
        onPanUpdate: (details) {
          // add a point when the user move the finger
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          _addPoint(localPosition);
        },
        onPanEnd: (details) {
          _saveDrawingAction(); // Save the action when the user stops drawing
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageList[_counter]),
              fit: BoxFit.cover,
            ),
          ),
          child: CustomPaint(
            painter: MyPainter(_drawingHistory, _onSelectDrawingAction),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Change Background',
            child: const Icon(Icons.keyboard_arrow_right),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _clearPoints,
            tooltip: 'Clear',
            child: const Icon(Icons.clear),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _undo,
            tooltip: 'Undo',
            child: const Icon(Icons.undo),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _redo,
            tooltip: 'Redo',
            child: const Icon(Icons.redo),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _openColorPicker,
            tooltip: 'Color',
            backgroundColor: _selectedColor,
            child: null,
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: () {
              _changeStrokeWidth(10);
            },
            tooltip: 'Width',
            child: Icon(Icons.line_weight),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: _deleteSelectedDrawingAction,
            tooltip: 'Delete',
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
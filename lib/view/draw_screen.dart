// draw_screen.dart
import 'package:easytech/model/drawing_action.dart';
import 'package:easytech/view/widgets/draw_widget/custom_colorpick_button.dart';
import 'package:easytech/view/widgets/draw_widget/custom_floating_action_button.dart';
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
  double _strokeWidth = 4.0;
  List<DrawingAction> _drawingHistory = [];
  List<DrawingAction> _redoStack = [];
  List<Offset> _currentPoints =
      <Offset>[]; // Store points for the current action

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
          points: [],
          color: _selectedColor,
          strokeWidth: _strokeWidth,
        );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text('Thickness:'),
                Container(

                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Slider(
                    value: _strokeWidth,
                    min: 1.0,
                    max: 10.0,
                    // divisions: 5,
                    label: _strokeWidth.toStringAsFixed(
                      1
                    ),
                    onChanged: (value) {
                      setState(() {
                        _strokeWidth = value;
                      });
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,

                  child: Row(
                    spacing: 10,
                    children: [
                      customColorPickButton(
                        color: Colors.white,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.white;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.grey,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.grey;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.black,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.black;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.yellow,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.yellow;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.orange,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.orange;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.green,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.green;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.deepPurple,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.deepPurple;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.purple,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.purple;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.pink,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.pink;
                          });
                        },
                        context: context,
                      ),
                      customColorPickButton(
                        color: Colors.red,
                        onTap: () {
                          setState(() {
                            _selectedColor = Colors.red;
                          });
                        },
                        context: context,
                      ),
                    ],
                  ),
                ),
                ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: _changeColor,
                  pickerAreaHeightPercent: 0.5,
                ),
              ],
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
          Offset localPosition = renderBox.globalToLocal(
            details.globalPosition,
          );
        },
        onPanStart: (details) {
          // add a point when start touching the screen
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(
            details.globalPosition,
          );
          _addPoint(localPosition);
        },
        onPanUpdate: (details) {
          // add a point when the user move the finger
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(
            details.globalPosition,
          );
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
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //for background
          customFloatingActionButton(
            onPressed: _incrementCounter,
            toolTip: 'Change Background',
            child: const Icon(Icons.keyboard_arrow_right),
          ),
          //for clear all  drawing
          customFloatingActionButton(
            onPressed: _clearPoints,
            toolTip: 'Clear',
            child: const Icon(Icons.clear),
          ),
          //undo
          customFloatingActionButton(
            onPressed: _undo,
            toolTip: 'Undo',
            child: const Icon(Icons.undo),
          ),
          //redo
          customFloatingActionButton(
            onPressed: _redo,
            toolTip: 'Redo',
            child: const Icon(Icons.redo),
          ),

          customFloatingActionButton(
            onPressed: _openColorPicker,
            selectedColor: _selectedColor,
            toolTip: 'Color',
          ),

          customFloatingActionButton(
            onPressed: () {
              _changeStrokeWidth(10);
            },
            toolTip: 'Width',
            child: Icon(Icons.line_weight),
          ),

          customFloatingActionButton(
            onPressed: _deleteSelectedDrawingAction,
            toolTip: 'Delete',
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

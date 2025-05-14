import 'package:easytech/model/drawing_action.dart';
import 'package:easytech/providers/drawing_provider.dart';
import 'package:easytech/view/widgets/background_widget/select_background.dart';
import 'package:easytech/view/widgets/draw_widget/custom_colorpick_button.dart';
import 'package:easytech/view/widgets/draw_widget/custom_floating_action_button.dart';
import 'package:easytech/view_model/mypainter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawScreen extends ConsumerStatefulWidget {
  const DrawScreen({super.key});

  @override
  ConsumerState<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends ConsumerState<DrawScreen> {
  List<String> imageList = [
    "assets/background_board/main_board.png",
    "assets/background_board/white_board.png",
    "assets/background_board/black_board.png",
    "assets/background_board/blue_cell.jpg",
    "assets/background_board/line_pattern.jpg",
    "assets/background_board/note_book.jpg",
    "assets/background_board/small_cell.png",
    "assets/background_board/striped_paper.jpg",
    "assets/background_board/football_background.jpg"
  ];


  void _addPoint(Offset point) {
    ref
        .read(drawingProvider.notifier)
        .addPoint(
          point,
          ref.watch(selectedColorProvider),
          ref.watch(strokeWidthProvider),
          // ref.watch(isErasingProvider), // <-- new
        );
  }

  deleteAlert() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            return AlertDialog(
              title: const Text('Alert!'),
              content: SingleChildScrollView(
                child: Text('u will delete all your drawing '),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(drawingProvider.notifier).clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openColorPicker({required double width}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            Color selectedColor = ref.watch(selectedColorProvider);
            double strokeWidth = ref.watch(strokeWidthProvider);

            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: Column(
                  spacing: 5,
                  children: [
                    Text('Thickness:'),
                    Slider(
                      value: strokeWidth,
                      min: 0,
                      max: 10,
                      label: strokeWidth.round().toString(),
                      onChanged: (value) {
                        ref.read(strokeWidthProvider.notifier).state = value;
                      },
                    ),

                    Wrap(
                      spacing: 5,
                      children: [
                        for (final color in [
                          Colors.black,
                          Colors.grey,
                          Colors.white,
                          Colors.yellow,
                          Colors.orange,
                          Colors.green,
                          Colors.deepPurple,
                          Colors.purple,
                          Colors.pink,
                          Colors.red,
                        ])
                          customColorPickButton(
                            color: color,
                            onTap: () {
                              ref.read(selectedColorProvider.notifier).state =
                                  color;
                            },
                            context: context,
                          ),
                      ],
                    ),
                    ColorPicker(
                      colorPickerWidth: width,
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        ref.read(selectedColorProvider.notifier).state = color;
                      },
                      pickerAreaHeightPercent: 0.5,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconHightSize = MediaQuery.of(context).size.height * 0.04;
    final iconWidethSize = MediaQuery.of(context).size.width * 0.03;
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          final localPos = (context.findRenderObject() as RenderBox)
              .globalToLocal(details.globalPosition);
          ref
              .read(drawingProvider.notifier)
              .addPoint(
                localPos,
                ref.read(selectedColorProvider),
                ref.read(strokeWidthProvider),
                isErasing: ref.read(isErasingProvider),
              );
        },
        onPanUpdate: (details) {
          final localPos = (context.findRenderObject() as RenderBox)
              .globalToLocal(details.globalPosition);
          ref
              .read(drawingProvider.notifier)
              .addPoint(
                localPos,
                ref.read(selectedColorProvider),
                ref.read(strokeWidthProvider),
                isErasing: ref.read(isErasingProvider),
              );
        },
        onPanEnd: (_) {
          ref.read(drawingProvider.notifier).finishDrawing();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: AssetImage(
                imageList[ref.watch(selectedBackgroundIndexProvider)],
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: CustomPaint(
            painter: MyPainter(
              drawingHistory: ref.watch(drawingProvider),
              onSelectDrawingAction: (_) {},
            ),
            size: Size.infinite,
          ),
        ),
      ),

      ///////////***********    floatingActionButton    ***********///////////
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blueGrey,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 5,
          children: [
            customFloatingActionButton(
              width: iconWidethSize,
              height: iconHightSize,
              onPressed:
                  () => _openColorPicker(
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
              toolTip: 'ColorPicker',
              child: Image.asset(
                "assets/icons/pen_flat.png",
                width: iconWidethSize,
                height: iconHightSize,
              ),
            ),
            customFloatingActionButton(
              width: iconWidethSize,
              height: iconHightSize,
              onPressed: () {
                selectedBackGround(context, ref);
              },
              toolTip: 'Change Background',
              child: Image.asset(
                "assets/icons/bg_flat.png",
                width: iconWidethSize,
                height: iconHightSize,
              ),
            ),
            customFloatingActionButton(
              width: iconWidethSize,
              height: iconHightSize,
              onPressed: () {
                deleteAlert();
              },
              toolTip: 'Clear',
              child: Image.asset(
                "assets/icons/clear_flat.png",
                width: iconWidethSize,
                height: iconHightSize,
              ),
            ),
            customFloatingActionButton(
              width: iconWidethSize,
              height: iconHightSize,
              onPressed: () => ref.read(drawingProvider.notifier).undo(),
              toolTip: 'Undo',
              child: Image.asset(
                "assets/icons/undo_flat.png",
                width: iconWidethSize,
                height: iconHightSize,
              ),
            ),
            customFloatingActionButton(
              width: iconWidethSize,
              height: iconHightSize,
              onPressed: () => ref.read(drawingProvider.notifier).redo(),
              toolTip: 'Redo',
              child: Image.asset(
                "assets/icons/redo_flat.png",
                width: iconWidethSize,
                height: iconHightSize,
              ),
            ),

            customFloatingActionButton(
              width: iconWidethSize,
              height: iconHightSize,
              onPressed: () {
                ref.read(isErasingProvider.notifier).state =
                    !ref.read(isErasingProvider);
                print(ref.read(isErasingProvider.notifier).state);
              },
              toolTip: 'Erase',
              selectedColor:
                  ref.watch(isErasingProvider)
                      ? Colors.blueGrey.shade400
                      : null,
              child: Image.asset(
                "assets/icons/WB_eraser.png",
                width: iconWidethSize,
                height: iconHightSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

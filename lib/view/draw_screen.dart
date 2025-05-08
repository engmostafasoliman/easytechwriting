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
    "assets/background_board/white_board.png",
    "assets/background_board/black_board.png",
    "assets/background_board/blue_cell.jpg",
    "assets/background_board/line_pattern.jpg",
    "assets/background_board/note_book.jpg",
    "assets/background_board/small_cell.png",
    "assets/background_board/striped_paper.jpg",
  ];
  final selectedColorProvider = StateProvider<Color>((ref) => Colors.black);
  final strokeWidthProvider = StateProvider<double>((ref) => 4.0);
  final isErasingProvider = StateProvider<bool>((ref) => false);

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

  void _openColorPicker() {
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
                          Colors.white,
                          Colors.grey,
                          Colors.black,
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 5,
        children: [
          customFloatingActionButton(
            onPressed: () {
              selectedBackGround(context, ref);
            },
            toolTip: 'Change Background',
            child: const Icon(CupertinoIcons.calendar_badge_minus),
          ),
          customFloatingActionButton(
            onPressed: () => ref.read(drawingProvider.notifier).clear(),
            toolTip: 'Clear',
            child: const Icon(CupertinoIcons.arrow_2_circlepath),
          ),
          customFloatingActionButton(
            onPressed: () => ref.read(drawingProvider.notifier).undo(),
            toolTip: 'Undo',
            child: const Icon(CupertinoIcons.arrowtriangle_left),
          ),
          customFloatingActionButton(
            onPressed: () => ref.read(drawingProvider.notifier).redo(),
            toolTip: 'Redo',
            child: const Icon(CupertinoIcons.arrowtriangle_right),
          ),
          customFloatingActionButton(
            onPressed: _openColorPicker,
            toolTip: 'Color',
            child: Icon(
              CupertinoIcons.square_pencil,
              color: ref.watch(selectedColorProvider),
            ),
          ),

          customFloatingActionButton(
            onPressed: () {
              ref.read(isErasingProvider.notifier).state =
                  !ref.read(isErasingProvider);
              print(ref.read(isErasingProvider.notifier).state);
            },
            toolTip: 'Erase',
            selectedColor:
                ref.watch(isErasingProvider) ? Colors.blueGrey : null,
            child: Image.asset(
              "assets/icons/WB_eraser.png",
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
    );
  }
}

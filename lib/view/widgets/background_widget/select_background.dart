
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageListProvider = Provider<List<String>>(
  (ref) => [
    "assets/background_board/main_board.png",
    "assets/background_board/white_board.png",
    "assets/background_board/black_board.png",
    "assets/background_board/blue_cell.jpg",
    "assets/background_board/line_pattern.jpg",
    "assets/background_board/note_book.jpg",
    "assets/background_board/small_cell.png",
    "assets/background_board/striped_paper.jpg",
    "assets/background_board/football_background.jpg"
  ],
);

final selectedBackgroundIndexProvider = StateProvider<int>((ref) => 0);

Future<void> selectedBackGround(BuildContext context, WidgetRef ref) {
  final imageList = ref.watch(imageListProvider);


  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pick your background !'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          child: GridView.builder(
            itemCount: imageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.80,
            ),
            itemBuilder:
                (context, index) => InkWell(
                  onTap: () {

                    ref.read(selectedBackgroundIndexProvider.notifier).state =
                        index;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(imageList[index], fit: BoxFit.cover),
                  ),
                ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Select'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';

List<String> imageList = [
  "assets/background_board/white_board.png",
  "assets/background_board/black_board.png",
  "assets/background_board/blue_cell.jpg",
  "assets/background_board/line_pattern.jpg",
  "assets/background_board/note_book.jpg",
  "assets/background_board/small_cell.png",
  "assets/background_board/striped_paper.jpg",
];
int selectedBackGroundNum = 0;

Future selectedBackGround(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pick your background !'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 200,

          child: StatefulBuilder(
            builder: (context, setState) {
              return GridView.builder(
                itemCount: imageList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 2 columns
                  crossAxisSpacing: 10, // horizontal spacing
                  mainAxisSpacing: 10, // vertical spacing
                  childAspectRatio: 1.80, // width/height ratio
                ),
                itemBuilder:
                    (context, index) => InkWell(
                      /////
                      onTap: () {
                        setState(() {
                          selectedBackGroundNum = index;
                        });
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5),
                          border:
                              selectedBackGroundNum == index
                                  ? Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),

                        child: Image.asset(imageList[index], fit: BoxFit.cover),
                      ),
                    ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('select'),
            onPressed: () {
              print(selectedBackGroundNum);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

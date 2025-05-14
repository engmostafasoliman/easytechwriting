import 'package:flutter/material.dart';

Widget customFloatingActionButton({
  required void Function()? onPressed,
   Color? selectedColor,
  required String toolTip,
  required double width,
  required double height,
  Widget? child,
}) {
  return SizedBox(
    height: height*1.9,
    width: width*1.35,
    child: FloatingActionButton(
      elevation: 0,

      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap ,

      onPressed: onPressed,
      tooltip: toolTip,
      backgroundColor: selectedColor??Colors.blueGrey,
      child: child,
    ),
  );
}

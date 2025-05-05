import 'package:flutter/material.dart';

Widget customFloatingActionButton({
  required void Function()? onPressed,
   Color? selectedColor,
  required String toolTip,
  Widget? child,
}) {
  return FloatingActionButton(

    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap ,
    shape: const CircleBorder(),
    onPressed: onPressed,
    tooltip: toolTip,
    backgroundColor: selectedColor??Colors.grey,
    child: child,
  );
}

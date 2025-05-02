import 'package:flutter/material.dart';

Widget customFloatingActionButton({
  required void Function()? onPressed,
   Color? selectedColor,
  required String toolTip,
  Widget? child,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: 'Color',
    backgroundColor: selectedColor??Colors.grey,
    child: child,
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customColorPickButton({
  required Color color,
  required Function()? onTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(

        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

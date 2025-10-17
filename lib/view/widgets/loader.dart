import 'package:flutter/material.dart';

Widget loader({
  double left = 0,
  double top = 0,
  double right = 0,
  double bottom = 0,
  double height = 40,
  double width = 40,
}) {
  return Center(
    child: Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: CircularProgressIndicator(
        color: const Color.fromARGB(255, 38, 99, 205),
        strokeWidth: 1.5,
      ),
    ),
  );
}

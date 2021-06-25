import 'package:flutter/material.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Glance",
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
      Text(
        "At",
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ],
  );
}

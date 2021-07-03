import 'package:flutter/material.dart';

Widget nextPage() {
  return Container(
    width: 100.0,
    height: 50.0,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    margin: EdgeInsets.only(right: 10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Icon(Icons.arrow_forward_ios),
    ),
  );
}

Widget prePage() {
  return Container(
    width: 100.0,
    height: 50.0,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    margin: EdgeInsets.only(left: 10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Icon(Icons.arrow_back_ios),
    ),
  );
}

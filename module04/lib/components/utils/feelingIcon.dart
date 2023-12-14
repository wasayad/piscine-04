import 'package:flutter/material.dart';

class FeelingIcon {
  FeelingIcon();
  final List<dynamic> icons = [
    Icons.sentiment_dissatisfied_outlined,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral_outlined,
    Icons.sentiment_satisfied,
    Icons.sentiment_satisfied_alt
  ];
  final List<dynamic> color = [
    Colors.red,
    Colors.deepOrange,
    Colors.yellowAccent,
    Colors.lightGreen,
    Colors.green,
  ];
}
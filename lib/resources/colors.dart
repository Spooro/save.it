import 'package:flutter/material.dart';

hexColor(value) {
  String newColor = '0xff' + value;
  newColor = newColor.replaceAll('#', '');
  var intColor = int.parse(newColor);
  return intColor;
}

Color greenDone = Color(hexColor('4cbb17'));
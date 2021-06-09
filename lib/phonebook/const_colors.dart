import 'package:flutter/material.dart';


const Color WHITE_COLOUR = Color(0xFFFFFFFF);
const Color BLACK_COLOUR = Color(0xFF000000);
const Color LIGHT_GREY_COLOUR = Color(0x80E7E7E7);
const Color MEDIUM_GREY_COLOUR = Color(0xFFA6A6A6);

LinearGradient getColorGradient(Color color) {
  var baseColor = color as dynamic;
  Color color1 = baseColor[800];
  Color color2 = baseColor[400];
  return LinearGradient(colors: [
    color1,
    color2,
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);
}
